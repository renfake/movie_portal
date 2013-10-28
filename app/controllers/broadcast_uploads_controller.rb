# coding: utf-8
require "roo"
class BroadcastUploadsController < ApplicationController
  def index
    @broadcast_uploads = BroadcastUpload.paginate(:page => params[:page], :per_page => params[:page_size] || 50).order("updated_at DESC")
  end

  def new
  end

  def create
    @skip_the_first_line = params[:skip_the_first_line] || false
    @go_with_warning = params[:go_with_warning] || false

    file = params[:file]
    if !file
      @broadcast_uploads = BroadcastUpload.paginate(:page => params[:page], :per_page => params[:page_size] || 50).order("updated_at DESC")
      flash[:error] = "upload file is empty!"
      render :action => 'index'
    else
      begin
        ext_name = File.extname file.original_filename
        if ext_name != '.xls' && ext_name != '.xlsx'
          @broadcast_uploads = BroadcastUpload.paginate(:page => params[:page], :per_page => params[:page_size] || 50).order("updated_at DESC")
          flash[:error] = "Only support excel file, file ext is #{ext_name}"
          render :action => 'index'
        else
          path = save_file file
          excl = nil
          if ext_name == '.xls'
            excl = ::Roo::Excel.new path
          else
            excl = ::Roo::Excelx.new path
          end

          broadcast_upload = BroadcastUpload.create! :file_name => file.original_filename,
                                                     :skip_the_first_line => @skip_the_first_line,
                                                     :go_with_warning => @go_with_warning,
                                                     :status => 'START',
                                                     :created_by => current_user.id


          analyze_upload_broadcasts excl, broadcast_upload

          if broadcast_upload.failed?
            @broadcast_uploads = BroadcastUpload.paginate(:page => params[:page], :per_page => params[:page_size] || 50).order("updated_at DESC")
            render :action => :index
            return
          end

          broadcast_upload.issues.reload

          if !@go_with_warning && !broadcast_upload.issue_records.empty?
            @broadcast_uploads = BroadcastUpload.paginate(:page => params[:page], :per_page => params[:page_size] || 50).order("updated_at DESC")
            render :action => :index
            return
          end

          parse_excl file, excl
          flash[:notice] = "Import OK"
          redirect_to broadcast_uploads_path
        end
      rescue => detail
        flash[:error] = detail.message
        @broadcast_uploads = BroadcastUpload.paginate(:page => params[:page], :per_page => params[:page_size] || 50).order("updated_at DESC")
        render :action => 'index'
      end
    end
  end

  def show
    @broadcast_upload = BroadcastUpload.find params[:id]

  end

  def destroy
  end

  private

  def analyze_upload_broadcasts(excl, broadcast_upload)
    sheet =excl.sheets.first
    if sheet.nil?
      flash[:error] = "NO Date"
      BroadcastUploadIssue.create! :broadcast_upload_id => broadcast_upload.id, :issue_type => 'ERROR', :root_cause => 'No Data'
      broadcast_upload.update_attributes :count => 0, :status => 'FAIL'
      return
    else
      start_row = excl.first_row(sheet)
      if start_row.nil?
        flash[:error] = "NO Data"
        BroadcastUploadIssue.create! :broadcast_upload_id => broadcast_upload.id, :issue_type => 'ERROR', :root_cause => 'No Data'
        broadcast_upload.update_attributes :count => 0, :status => 'FAIL'
        return
      end
      start_row +=1 if broadcast_upload.skip_the_first_line
      last_row = excl.last_row(sheet)
      count = last_row - start_row + 1
      if count == 0
        flash[:error] = "NO Data"
        BroadcastUploadIssue.create! :broadcast_upload_id => broadcast_upload.id, :issue_type => 'ERROR', :root_cause => 'No Data'
        broadcast_upload.update_attributes :count => 0, :status => 'FAIL'
        return
      else
        broadcast_upload.update_attribute :count, count
        (start_row..last_row).each do |row|
          begin
            # Check Date
            date_celltype = excl.celltype(row, 3, sheet)
            raw_date =  excl.cell(row, 3, sheet)
            date = nil
            if date_celltype == :date
              date =  raw_date
            else

              date = Date.strptime(raw_date.to_s, '%m/%d/%Y') rescue nil
            end

            if date.nil?
              BroadcastUploadIssue.create! :broadcast_upload_id => broadcast_upload.id, :row => row, :column => 3, :field_name => 'DATE',
                                           :issue_type => 'ERROR', :root_cause => "日期为空或格式不正确 :#{raw_date}"
            end

            # Check Time
            time_celltype = excl.celltype(row, 4, sheet)
            raw_time = excl.cell(row, 4, sheet)
            time = nil
            if time_celltype == :time
              time =  raw_time
            else
              raw_time = excl.cell(row, 4, sheet).to_s
              time = Time.parse(raw_time.to_s) rescue nil
            end


            if time.nil?
              BroadcastUploadIssue.create! :broadcast_upload_id => broadcast_upload.id, :row => row, :column => 4, :field_name => 'TIME',
                                           :issue_type => 'ERROR', :root_cause => "时间为空或格式不正确 :#{raw_time}"
            end

            # Check Movie
            raw_movie_name = excl.cell(row, 6, sheet).to_s
            raw_movie_name.strip!
            movie_names = raw_movie_name.split(/\s+/)
            movie_name= movie_names.last || ''

            movie_name.gsub!(/$首映/, '') if movie_name.start_with?('首映')

            match = /\[\[id:\s*(?<movie_id>\d+)\s*\]\]\s*$/.match movie_name

            if match
              movie = Movie.find(match[:movie_id]) rescue nil
              unless movie
                BroadcastUploadIssue.create! :broadcast_upload_id => broadcast_upload.id, :row => row, :column => 6, :field_name => 'MOVIE',
                                             :issue_type => 'ERROR',
                                             :root_cause => "指定ID的电影不存在"
              end
            else
              movies = Movie.find_all_by_name  movie_name
              if movies.size != 1
                BroadcastUploadIssue.create! :broadcast_upload_id => broadcast_upload.id, :row => row, :column => 6, :field_name => 'MOVIE',
                                             :issue_type => 'ERROR',
                                             :root_cause => movies.empty? ? "电影为空" : "同名电影"
              end
            end

            # audience_rating
            raw_audience_rating = excl.cell(row, 7, sheet).to_s.strip

            unless raw_audience_rating =~ /^\d+??(?:\.\d{0,6})?$/
              if raw_audience_rating.empty?
                BroadcastUploadIssue.create! :broadcast_upload_id => broadcast_upload.id, :row => row, :column => 7, :field_name => 'AUDIENCE_RATING',
                                             :issue_type => 'WARNING',
                                             :root_cause => "收视率为空"
              else
                BroadcastUploadIssue.create! :broadcast_upload_id => broadcast_upload.id, :row => row, :column => 7, :field_name => 'AUDIENCE_RATING' ,
                                             :issue_type => 'ERROR',
                                             :root_cause => "收视率格式错误"
              end

            end

            # audience_share
            raw_audience_share = excl.cell(row, 8, sheet).to_s.strip
            unless raw_audience_share =~ /^\d+??(?:\.\d{0,6})?$/
              if raw_audience_share.empty?
                BroadcastUploadIssue.create! :broadcast_upload_id => broadcast_upload.id, :row => row,  :column => 8, :field_name => 'AUDIENCE_SHARE',
                                             :issue_type => 'WARNING',
                                             :root_cause => "收视份额为空"
              else
                BroadcastUploadIssue.create! :broadcast_upload_id => broadcast_upload.id, :row => row,  :column => 8, :field_name => 'AUDIENCE_SHARE',
                                             :issue_type => 'ERROR',
                                             :root_cause => "收视份额格式错误"
              end

            end

            # audience_number
            audience_number_celltype = excl.celltype(row, 9, sheet)
            raw_audience_number = excl.cell(row, 9, sheet)

            if audience_number_celltype == :float
               unless raw_audience_number
                 BroadcastUploadIssue.create! :broadcast_upload_id => broadcast_upload.id, :row => row,   :column => 9, :field_name => 'AUDIENCE_NUMBER',
                                              :issue_type => 'WARNING',
                                              :root_cause => "观众人数为空"
               end
            else
              audience_number = raw_audience_number.to_s.strip
              unless audience_number =~ /^\d+$/
                if audience_number.empty?
                  BroadcastUploadIssue.create! :broadcast_upload_id => broadcast_upload.id, :row => row,  :column => 9, :field_name => 'AUDIENCE_NUMBER',
                                               :issue_type => 'WARNING',
                                               :root_cause => "观众人数为空"
                else
                  BroadcastUploadIssue.create! :broadcast_upload_id => broadcast_upload.id, :row => row,  :column => 9, :field_name => 'AUDIENCE_NUMBER',
                                               :issue_type => 'ERROR',
                                               :root_cause => "观众人数格式错误"
                end
              end
            end

            # time_bucket
            time_bucket_celltype =  excl.celltype(row, 10, sheet)
            raw_time_bucket = excl.cell(row, 10, sheet)
            if time_bucket_celltype == :float
               unless raw_time_bucket
                 BroadcastUploadIssue.create! :broadcast_upload_id => broadcast_upload.id, :row => row, :column => 10, :field_name => 'TIME_BUCKET',
                                              :issue_type => 'WARNING',
                                              :root_cause => "时段为空"
               end
            else
              time_bucket = raw_time_bucket.to_s.strip
              unless time_bucket =~ /^\d+$/
                if time_bucket.empty?
                  BroadcastUploadIssue.create! :broadcast_upload_id => broadcast_upload.id, :row => row, :column => 10, :field_name => 'TIME_BUCKET',
                                               :issue_type => 'WARNING',
                                               :root_cause => "时段为空"
                else
                  BroadcastUploadIssue.create! :broadcast_upload_id => broadcast_upload.id, :row => row, :column => 10, :field_name => 'TIME_BUCKET' ,
                                               :issue_type => 'ERROR',
                                               :root_cause => "时段格式不对"
                end
              end
            end



          rescue => detail
            BroadcastUploadIssue.create! :broadcast_upload_id => broadcast_upload.id, :row => row, :issue_type => 'ERROR', :root_cause => detail.message
          end
        end

        # UPdate
        broadcast_upload.error_records.reload
        unless broadcast_upload.error_records.empty?
          broadcast_upload.update_attribute :status, 'FAIL'
        end

      end

    end

  end

  def save_file(file)
    now = Time.now

    name = file.original_filename
    directory = 'public/data'
    # create the file path
    path = File.join(Rails.root, directory, name)
    # write the file
    # upload_file = File.new(file, "rb").read
    File.open(path, "wb") { |f| f.write(file.read) }
    path
  end

  def parse_excl(file, excl)
    #wordlists = Wordlist.where ["import_file=?", file.original_filename]
    #wordlists.each do |wordlist|
    #  wordlist.destroy
    #end

    #excl.sheets.each do |sheet|
    sheet = excl.sheets.first
    if sheet.nil?
      flash[:error] = "No Data"

    else
      ((excl.first_row(sheet)+1)..excl.last_row(sheet)).each do |row|
        Rails.logger.info "Process #{row}"
        begin
          raw_category = excl.cell(row, 5, sheet).to_s
          raw_category.strip!
          categories = raw_category.split(/\s+/)
          first_run = categories.include? '首映'

          category = categories.first || ''
          category.strip!
          category = '' if category == '首映'


          raw_movie_name = excl.cell(row, 6, sheet).to_s
          raw_movie_name.strip!
          movie_names = raw_movie_name.split(/\s+/)
          first_run = first_run || movie_names.include?('首映')
          movie_name= movie_names.last || ''

          first_run = first_run || movie_name.start_with?('首映')
          movie_name.gsub!(/$首映/, '') if movie_name.start_with?('首映')


          raw_runtime = excl.cell(row, 15, sheet).to_s
          raw_runtime.strip!
          runtime = 0
          match = /(?:(?<minute>\d+)\')?(?:(?<second>\d+)\")?/.match(raw_runtime)

          runtime = match[:minute].to_i * 60 if match[:minute]
          runtime += match[:second].to_i if match[:second]

          if movie_name.empty?
            if !flash[:error]
              flash[:error] = "Excel has empty movie name in #{sheet}, #{row} row. "
            else
              flash[:error] += "Excel has empty movie name in #{sheet}, #{row} row."
            end
            continue
          end
          #movie_name.gsub!(/#{category}\s+/, '')

          movie = Movie.find_or_initialize_by_name(movie_name)

          if movie.new_record?

            movie_category = nil
            unless category.empty?
              movie_category = Category.find_or_initialize_by_name category
              movie_category.save! if movie_category.new_record?
            end

            movie.country = '中国'
            movie.category = movie_category
            movie.first_run = first_run
            movie.runtime = runtime


            movie.save!
          end

        rescue
          flash[:error] = "Fail to add Movie: #{movie_name} Category: #{category} by #{$!.to_s} \n at #{row}"
          raise
        end
      end

      #end

    end
  end
end

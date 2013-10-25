# coding: utf-8
require "roo"
class BroadcastUploadsController < ApplicationController
  def index
    @broadcast_uploads = BroadcastUpload.paginate(:page => params[:page], :per_page => params[:page_size] || 50).order("updated_at DESC")
  end

  def new
  end

  def create
    @skip_the_first_line = params[:skip_the_first_line]
    @go_with_warning = params[:go_with_warning]

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

          parse_excl file, excl
          flash[:notice] = "Import OK"
          redirect_to broadcast_uploads_path
        end
      rescue
        render :action => 'index'
      end
    end
  end

  def show

  end

  def destroy
  end

  private

  def analyze_upload_broadcasts(excl, broadcast_upload)
    sheet =excl.sheets.first
    if sheet.nil?
      flash[:error] = "NO Date"
      BroadcastUploadIssue.create! :broadcast_upload_id => broadcast_upload.id, :row => 0, :issue_type => 'ERROR', :root_cause => 'No Data'
    else
      start_row = excl.first_row(sheet)
      if start_row.nil?
        flash[:error] = "NO Data"
        BroadcastUploadIssue.create! :broadcast_upload_id => broadcast_upload.id, :row => 0, :issue_type => 'ERROR', :root_cause => 'No Data'
        broadcast_upload.count = 0
        return
      end
      start_row +=1 if broadcast_upload.skip_the_first_line
      last_row = excl.last_row(sheet)
      count = last_row - start_row + 1
      if count == 0
        flash[:error] = "NO Data"
        BroadcastUploadIssue.create! :broadcast_upload_id => broadcast_upload.id, :row => 0, :issue_type => 'ERROR', :root_cause => 'No Data'
      else
         (start_row..last_row).each  do |row|
           begin

           rescue

           end
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

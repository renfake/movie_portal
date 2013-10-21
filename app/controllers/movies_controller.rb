# coding: utf-8
require "roo"
class MoviesController < ApplicationController

  def index
    @movies = Movie.paginate(:page => params[:page], :per_page => params[:page_size] || 50)
  end

  def new
    @movie = Movie.new
  end

  def create
    @movie = Movie.new params[:movie]
    if @movie.save
      flash[:notice] = '添加成功'
      redirect_to movies_path
    else
      flash[:error] = @movie.errors
      render :action => :new
    end
  end

  def edit

  end

  def update

  end


  def process_import
    file = params[:file]
    if !file
      flash[:error] = "upload file is empty!"
      render :action => 'import'
    else
      begin
        ext_name = File.extname file.original_filename
        if ext_name != '.xls' && ext_name != '.xlsx'
          flash[:error] = "Only support excel file, file ext is #{ext_name}"
          render :action => 'import'
        else
          path = save_file file
          excl = nil
          if ext_name == '.xls'
            excl = ::Roo::Excel.new path
          else
            excl = ::Roo::Excelx.new path
          end

          parse_excl file, excl
          flash[:notice] = "Import OK"
          redirect_to movies_path
        end
      rescue


        render :action => 'import'
      end
    end
  end


  def show
    @movie = Movie.find params[:id]
    unless @movie
      flash[:error] = "没有相关电影记录"
      redirect_back_or_default movies_path
    end
  end

  def destroy
    movie = Movie.find params[:id]
    if movie
      flash[:notice] = "电影删除成功"
      movie.destroy
    else
      flash[:error] = "未找到要删除的电影"
    end
    redirect_back_or_default movies_path
  end

  private

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

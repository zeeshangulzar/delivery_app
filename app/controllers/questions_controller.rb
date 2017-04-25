class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [:show, :edit, :update, :destroy, :index]
  before_action :set_question, only: [:show, :edit, :update, :destroy]
  before_action :token_authentication, only: [:display_questions, :save_answers]
  before_action :check_params, only: [:save_answers]
  
  # GET /questions
  # GET /questions.json
  def index
    @questions = Question.search(params).page(params[:page]).per(10)
    @question = Question.new
  end

  def display_questions
    @questions = Question.where(active: true).last(5)
  end

  def save_answers
    params[:answers].each do |answer|
      @question = Question.find_by_id(answer["question_id"])
       return render json: { error: "Question #{answer["question_id"]} not found"}, status: 404 if @question.blank?
      @question.answers.create(content: answer["content"], count: answer["count"])
    end
    return render json: { mesage: "successfull "}, status: 200 
  end

  # GET /questions/1
  # GET /questions/1.json
  def show
    @rating1 = @question.answers.where(count: 1).count
    @rating2 = @question.answers.where(count: 2).count
    @rating3 = @question.answers.where(count: 3).count
    @rating4 = @question.answers.where(count: 4).count
    @rating5 = @question.answers.where(count: 5).count

  end

  # GET /questions/new
  def new
    @question = Question.new
  end

  # GET /questions/1/edit
  def edit
     respond_to do |format|
        format.html
      end
  end

  # POST /questions
  # POST /questions.json
  def create
    @question = Question.new(question_params)

    respond_to do |format|
      if @question.save
        format.js
        format.json { render :show, status: :created, location: @question }
      else
        format.html { render :new }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /questions/1
  # PATCH/PUT /questions/1.json
  def update
    respond_to do |format|
      if @question.update(question_params)
        format.js
        format.json { render :show, status: :ok, location: @question }
      else
        format.html { render :edit }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /questions/1
  # DELETE /questions/1.json
  def destroy
    @question.destroy
    respond_to do |format|
      format.html { redirect_to questions_url, notice: 'Question was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_question
      @question = Question.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def question_params
      params.require(:question).permit(:content, :active)
    end



    def check_params
    params[:answers].each.with_index do |answer, answer_index|
      return render json: { error: "Please provide question id "}, status: 404 if answer["question_id"].blank?
      return render json: { error: "Rating count can not be blank "}, status: 404 if answer["count"].blank?
    end
    end

end

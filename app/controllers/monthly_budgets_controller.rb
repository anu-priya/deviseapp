class MonthlyBudgetsController < ApplicationController
  # GET /monthly_budgets
  # GET /monthly_budgets.json
  def index
    @monthly_budgets = MonthlyBudget.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @monthly_budgets }
    end
  end

  # GET /monthly_budgets/1
  # GET /monthly_budgets/1.json
  def show
    @monthly_budget = MonthlyBudget.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @monthly_budget }
    end
  end

  # GET /monthly_budgets/new
  # GET /monthly_budgets/new.json
  def new
    @monthly_budget = MonthlyBudget.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @monthly_budget }
    end
  end

  # GET /monthly_budgets/1/edit
  def edit
    @monthly_budget = MonthlyBudget.find(params[:id])
  end

  # POST /monthly_budgets
  # POST /monthly_budgets.json
  def create
    @monthly_budget = MonthlyBudget.new(params[:monthly_budget])

    respond_to do |format|
      if @monthly_budget.save
        format.html { redirect_to @monthly_budget, notice: 'Monthly budget was successfully created.' }
        format.json { render json: @monthly_budget, status: :created, location: @monthly_budget }
      else
        format.html { render action: "new" }
        format.json { render json: @monthly_budget.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /monthly_budgets/1
  # PUT /monthly_budgets/1.json
  def update
    @monthly_budget = MonthlyBudget.find(params[:id])

    respond_to do |format|
      if @monthly_budget.update_attributes(params[:monthly_budget])
        format.html { redirect_to @monthly_budget, notice: 'Monthly budget was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @monthly_budget.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /monthly_budgets/1
  # DELETE /monthly_budgets/1.json
  def destroy
    @monthly_budget = MonthlyBudget.find(params[:id])
    @monthly_budget.destroy

    respond_to do |format|
      format.html { redirect_to monthly_budgets_url }
      format.json { head :no_content }
    end
  end
end

class ParsedEmailRecordsController < ApplicationController
  before_action :set_parsed_email_record, only: %i[ show edit update destroy ]

  # GET /parsed_email_records or /parsed_email_records.json
  def index
    @parsed_email_records = ParsedEmailRecord.all
  end

  # GET /parsed_email_records/1 or /parsed_email_records/1.json
  def show
  end

  # GET /parsed_email_records/new
  def new
    @parsed_email_record = ParsedEmailRecord.new
  end

  # GET /parsed_email_records/1/edit
  def edit
  end

  # POST /parsed_email_records or /parsed_email_records.json
  def create
    @parsed_email_record = ParsedEmailRecord.new(parsed_email_record_params)

    respond_to do |format|
      if @parsed_email_record.save
        format.html { redirect_to @parsed_email_record, notice: "Parsed email record was successfully created." }
        format.json { render :show, status: :created, location: @parsed_email_record }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @parsed_email_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /parsed_email_records/1 or /parsed_email_records/1.json
  def update
    respond_to do |format|
      if @parsed_email_record.update(parsed_email_record_params)
        format.html { redirect_to @parsed_email_record, notice: "Parsed email record was successfully updated." }
        format.json { render :show, status: :ok, location: @parsed_email_record }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @parsed_email_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /parsed_email_records/1 or /parsed_email_records/1.json
  def destroy
    @parsed_email_record.destroy!

    respond_to do |format|
      format.html { redirect_to parsed_email_records_path, status: :see_other, notice: "Parsed email record was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_parsed_email_record
      @parsed_email_record = ParsedEmailRecord.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def parsed_email_record_params
      params.expect(parsed_email_record: [ :inbound_email_id, :email, :type, :data, :sent_at ])
    end
end

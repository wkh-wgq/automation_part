class ParsedEmailRecordsController < ApplicationController
  before_action :set_parsed_email_record, only: %i[ show edit update destroy original_mail ]

  # GET /parsed_email_records or /parsed_email_records.json
  def index
    @parsed_email_records = ParsedEmailRecord
    @parsed_email_records = @parsed_email_records.where(type: params[:type]) if params[:type].present?
    @parsed_email_records = @parsed_email_records.where(email: params[:email]) if params[:email].present?
    @parsed_email_records = @parsed_email_records.order(created_at: :desc).page(page_params)
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

  def original_mail
    mail = @parsed_email_record.inbound_email.mail
    @subject = mail.subject
    if mail.text_part.present?
      @content_text = mail.text_part.decoded
    else
      raw_body = mail.body.decoded.gsub(/\\x([0-9a-fA-F]{2})/) { |m| $1.hex.chr }
      # 解析原始编码
      detected = CharDet.detect(raw_body)
      original_encoding = detected["encoding"] || "UTF-8"
      @content_text = raw_body.force_encoding(original_encoding).encode("UTF-8", invalid: :replace, undef: :replace)
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

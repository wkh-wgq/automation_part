class ApplicationMailbox < ActionMailbox::Base
  delegate :logger, to: :Rails
  # 官方取消订单
  routing ->(inbound_email) { inbound_email.mail.subject.include?("注文キャンセルのお知らせ") } => :pokermon_cancel_order
  # 下单
  routing ->(inbound_email) { inbound_email.mail.subject.include?("注文完了のお知らせ") } => :pokermon_place_order
  # 抽签中奖
  routing ->(inbound_email) { inbound_email.mail.subject.include?("当選のご案内") } => :pokermon_lottery_won
  # 发货
  routing ->(inbound_email) { inbound_email.mail.subject.include?("商品が出荷されました") } => :pokermon_deliver
  # 订单退回
  routing ->(inbound_email) { inbound_email.mail.subject.include?("ご注文の件について") } => :pokermon_return_order
  # 注册账号
  routing ->(inbound_email) { inbound_email.mail.subject.include?("会員登録の手続きへ進む") } => :pokermon_register
  # 重置密码
  routing ->(inbound_email) { inbound_email.mail.subject.include?("変更手続きへ進む") } => :pokermon_reset_password
  # 重置密码成功
  routing ->(inbound_email) { inbound_email.mail.subject.include?("パスワード変更完了のお知らせ") } => :pokermon_reset_password_success
  # 参加抽奖成功
  routing ->(inbound_email) { inbound_email.mail.subject.include?("応募完了のお知らせ") } => :pokermon_draw_lot_success
  # 注册成功
  routing ->(inbound_email) { inbound_email.mail.subject.include?("会員登録完了のお知らせ") } => :pokermon_register_success
  # 登陆验证码
  routing ->(inbound_email) { inbound_email.mail.subject.include?("ログイン用パスコードのお知らせ") } => :pokermon_login_captcha
end

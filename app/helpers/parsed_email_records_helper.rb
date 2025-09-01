module ParsedEmailRecordsHelper
  def type_for_select
    types_hash.map do |k, v|
      [ v, k ]
    end.unshift([ "请选择邮箱", "" ])
  end

  def parse_type(type)
    res = types_hash[type]
    res ? res : "其他(#{type})"
  end

  def types_hash
    {
      "deliver" => "商品が出荷されました",
      "place_order" => "注文完了のお知らせ",
      "register_success" => "会員登録完了のお知らせ",
      "draw_lot_success" => "応募完了のお知らせ",
      "reset_password_success" => "パスワード変更完了のお知らせ",
      "lottery_won" => "当選のご案内",
      "tencent_auto_forwarding_verification" => "腾讯企业邮箱自动转发验证"
    }
  end
end

resource "aws_ses_template" "order_confirmed" {
  name    = "Morder-confirmed-template"
  subject = "Importante!"
  html    = "<h1>Invoice gerada {{InvoiceNumber}} com sucesso, para order {{OrderId}}!</h1>"
  text    = "h1>Invoice gerada {{InvoiceNumber}} com sucesso, para order {{OrderId}}!"
}

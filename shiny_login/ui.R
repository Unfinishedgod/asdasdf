
ui <- fluidPage(
  tags$h2("My secure application"),
  verbatimTextOutput("auth_output")
)

ui <- secure_app(ui)
server <- function(input, output, session) {
  res_auth <- secure_server(check_credentials = check_credentials(credentials))
  
}
# shinyApp(ui, server)
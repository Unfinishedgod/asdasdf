## app.R ##
library(shinydashboard)
library(shiny)

ui <- dashboardPage(
  dashboardHeader(title = "Basic dashboard"),   # Header title
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")), # Tab 항목 추가
      menuItem("Widgets", tabName = "widgets", icon = icon("th"))
    )
  ),
  
  
  dashboardBody(
    tabItems(
      # First tab content
      tabItem(tabName = "dashboard",                      # 처음 Tab 항목에 box들 포함
              # Boxes need to be put in a row (or column)
              fluidRow(
                box(plotOutput("plot1", height = 250)),   # 해당 box에 plot1 부여
                
                box(
                  title = "Controls",
                  sliderInput("slider", "Number of observations:", 1, 100, 50)  # 해당 box에 slider 부여
                )
              )
      ),
      
      # Second tab content
      tabItem(tabName = "widgets",                       # 다음 Tab 항목엔 머리글만 추가
              h2("Widgets tab content")
      )
    )
  )
)



server <- function(input, output) {
  set.seed(122)
  histdata <- rnorm(500)   # 정규분포에서 랜덤으로 500개의 난수 생성
  
  output$plot1 <- renderPlot({                # 히스토그램을 plot1에 연동
    data <- histdata[seq_len(input$slider)]   # obs 조정바를 slider에 연동
    hist(data)
  })
}

shinyApp(ui, server)

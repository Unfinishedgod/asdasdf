library(shiny)
library(RSQLite)
library(DBI)

makereactivetrigger <- function() {
  rv <- reactiveValues(a = 0)
  list(
    depend = function() {
      rv$a
      invisible()
    },
    trigger = function() {
      rv$a <- isolate(rv$a + 1)
    }
  )
}

dbtrigger <- makereactivetrigger()

# con <- dbConnect(RSQLite::SQLite(), ":memory:")

con <- dbConnect(SQLite(), 
                 dbname = "shiny_exam_1/test_sqlte.sqlite")

ui <- fluidPage(
  numericInput('col1', 'col1', value = 1L, step = 1L),
  textInput('col2', 'col2', value = 'a'),
  actionButton('writetodb', 'Save'),
  tableOutput('dbtable')
)

server <- function(input, output) {
  mytableinshiny <- reactive({
    dbtrigger$depend()
    dbGetQuery(con, 'SELECT col1, col2 from mytable')
  })
  
  observeEvent(input$writetodb, {
    sql <- sqlInterpolate(con, 'INSERT INTO mytable ([col1], [col2]) VALUES (?col1, ?col2)',
                          col1 = input$col1, col2 = input$col2)
    dbExecute(con, sql)
    dbtrigger$trigger()
  })
  
  output$dbtable <- renderTable({
    mytableinshiny()
  })
}

shinyApp(ui = ui, server = server)


dbGetQuery(con, "SELECT * FROM iris_db")
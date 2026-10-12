# ============================================================
# MYGROWTH STUDIO - PERSONAL ACTIVITY ANALYZER
# ============================================================

# Install once if needed:
# install.packages(c("shiny", "ggplot2"))

library(shiny)
library(ggplot2)

# Store data in the current working directory
data_file <- "mygrowth_data.rds"

if (file.exists(data_file)) {
  saved_data <- readRDS(data_file)
} else {
  saved_data <- list(
    activities = data.frame(
      date = as.Date(character()),
      study = numeric(),
      work = numeric(),
      sleep = numeric(),
      exercise = numeric(),
      screen = numeric(),
      mood = integer(),
      stress = integer(),
      notes = character()
    ),
    goals = data.frame(
      goal = character(),
      category = character(),
      done = logical()
    )
  )
}

ui <- fluidPage(
  tags$head(
    tags$title("MyGrowth - Personal Analyzer"),
    tags$style(HTML("
      body {
        background: #f6f7ff;
        color: #202344;
        font-family: Arial, sans-serif;
      }
      .container-fluid {
        max-width: 1400px;
        padding: 24px;
      }
      .brand {
        font-size: 28px;
        font-weight: bold;
        margin-bottom: 20px;
      }
      .hero {
        background: linear-gradient(120deg,#e7e4ff,#e1f8ef);
        padding: 30px;
        border-radius: 22px;
        margin-bottom: 25px;
      }
      .card {
        background: white;
        border: 1px solid #e9e8f6;
        border-radius: 16px;
        padding: 22px;
        margin-bottom: 18px;
        box-shadow: 0 5px 15px rgba(30,30,70,.04);
      }
      .metric {
        background: #f0eeff;
        border-radius: 14px;
        padding: 18px;
        margin-bottom: 12px;
      }
      .metric-green { background: #e4f9ef; }
      .metric-orange { background: #fff0e5; }
      .number {
        font-size: 28px;
        font-weight: bold;
      }
      .btn {
        border-radius: 10px;
        font-weight: bold;
      }
      .btn-primary {
        background: #7565ee;
        border-color: #7565ee;
      }
      .form-control {
        border-radius: 9px;
      }
      .suggestion {
        background: #f0eeff;
        padding: 15px;
        border-radius: 12px;
        margin-bottom: 10px;
      }
      .small-text {
        color: #777c98;
        font-size: 13px;
      }
    "))
  ),
  
  div(
    class = "brand",
    HTML("MyGrowth ✦ <div class='small-text'>PERSONAL ACTIVITY ANALYZER</div>")
  ),
  
  div(
    class = "hero",
    h1("Understand your day. Improve your life."),
    p("Track your activities, understand your habits, and build a better routine."),
    strong("YOUR ACTIVITIES · YOUR INSIGHTS · YOUR GROWTH")
  ),
  
  tabsetPanel(
    id = "main_tab",
    
    # --------------------------------------------------------
    # DAILY ACTIVITY TRACKER
    # --------------------------------------------------------
    
    tabPanel(
      "Daily Activities",
      
      br(),
      
      fluidRow(
        column(
          7,
          
          div(
            class = "card",
            
            h3("Record your day"),
            p(class = "small-text",
              "Enter your activities for the selected date."),
            
            dateInput(
              "activity_date",
              "Date",
              value = Sys.Date()
            ),
            
            fluidRow(
              column(
                6,
                numericInput(
                  "study_hours", "📚 Study hours",
                  value = 3, min = 0, max = 24, step = 0.5
                )
              ),
              column(
                6,
                numericInput(
                  "work_hours", "💻 Work hours",
                  value = 0, min = 0, max = 24, step = 0.5
                )
              )
            ),
            
            fluidRow(
              column(
                6,
                numericInput(
                  "sleep_hours", "🌙 Sleep hours",
                  value = 8, min = 0, max = 24, step = 0.5
                )
              ),
              column(
                6,
                numericInput(
                  "exercise_minutes", "🏃 Exercise minutes",
                  value = 20, min = 0, max = 1440
                )
              )
            ),
            
            fluidRow(
              column(
                6,
                numericInput(
                  "screen_hours", "📱 Screen time hours",
                  value = 3, min = 0, max = 24, step = 0.5
                )
              ),
              column(
                6,
                sliderInput(
                  "mood_score", "😊 Mood",
                  min = 1, max = 10, value = 7
                )
              )
            ),
            
            sliderInput(
              "stress_score", "😟 Stress level",
              min = 1, max = 10, value = 4
            ),
            
            textAreaInput(
              "day_notes",
              "Notes about your day",
              placeholder = "What did you learn? What went well? What was difficult?",
              rows = 3
            ),
            
            actionButton(
              "save_activity",
              "Save Daily Activity",
              class = "btn-primary"
            ),
            
            br(),
            br(),
            uiOutput("save_message")
          )
        ),
        
        column(
          5,
          
          div(
            class = "card",
            h3("Today's overview"),
            uiOutput("today_overview")
          ),
          
          div(
            class = "card",
            h3("Daily reflection"),
            p("Answer these questions honestly:"),
            tags$ul(
              tags$li("What was my biggest achievement today?"),
              tags$li("What distracted me?"),
              tags$li("What is one thing I can improve tomorrow?")
            ),
            p(
              class = "small-text",
              "Use the notes box to record your reflection."
            )
          )
        )
      )
    ),
    
    # --------------------------------------------------------
    # PERSONAL ANALYZER
    # --------------------------------------------------------
    
    tabPanel(
      "Personal Analyzer",
      
      br(),
      
      fluidRow(
        column(
          3,
          div(
            class = "metric",
            h4("Productivity"),
            div(class = "number", textOutput("productivity_score")),
            p(class = "small-text", "Out of 100")
          )
        ),
        
        column(
          3,
          div(
            class = "metric metric-green",
            h4("Wellbeing"),
            div(class = "number", textOutput("wellbeing_score")),
            p(class = "small-text", "Out of 100")
          )
        ),
        
        column(
          3,
          div(
            class = "metric metric-orange",
            h4("Mood"),
            div(class = "number", textOutput("mood_display")),
            p(class = "small-text", "Out of 10")
          )
        ),
        
        column(
          3,
          div(
            class = "metric",
            h4("Sleep"),
            div(class = "number", textOutput("sleep_display")),
            p(class = "small-text", "Hours")
          )
        )
      ),
      
      div(
        class = "card",
        h3("Your personal analysis"),
        uiOutput("analysis_text")
      ),
      
      div(
        class = "card",
        h3("Personalized suggestions"),
        uiOutput("suggestions")
      ),
      
      div(
        class = "card",
        h3("Activity balance"),
        plotOutput("activity_chart", height = "300px")
      )
    ),
    
    # --------------------------------------------------------
    # GOALS AND HABITS
    # --------------------------------------------------------
    
    tabPanel(
      "Goals & Habits",
      
      br(),
      
      fluidRow(
        column(
          5,
          
          div(
            class = "card",
            h3("Create a personal goal"),
            
            textInput(
              "goal_name",
              "Goal",
              placeholder = "Example: Study R programming daily"
            ),
            
            selectInput(
              "goal_category",
              "Category",
              choices = c(
                "Study",
                "Career",
                "Health",
                "Personal Growth",
                "Communication",
                "Other"
              )
            ),
            
            actionButton(
              "add_goal",
              "Add Goal +",
              class = "btn-primary"
            ),
            
            br(),
            br(),
            uiOutput("goal_message")
          )
        ),
        
        column(
          7,
          
          div(
            class = "card",
            h3("My goals"),
            uiOutput("goal_list")
          )
        )
      )
    ),
    
    # --------------------------------------------------------
    # PROGRESS AND REPORTS
    # --------------------------------------------------------
    
    tabPanel(
      "Progress Reports",
      
      br(),
      
      div(
        class = "card",
        h3("Daily productivity trend"),
        p(class = "small-text",
          "Review how your recorded scores change over time."),
        plotOutput("trend_chart", height = "320px")
      ),
      
      div(
        class = "card",
        h3("Activity history"),
        tableOutput("activity_table"),
        br(),
        downloadButton(
          "download_csv",
          "Export Activities as CSV"
        )
      ),
      
      div(
        class = "card",
        h3("Data management"),
        p("Your activities and goals are stored in a local RDS file."),
        actionButton(
          "reload_data",
          "Refresh Saved Data"
        )
      )
    )
  )
)

server <- function(input, output, session) {
  
  activities <- reactiveVal(saved_data$activities)
  goals <- reactiveVal(saved_data$goals)
  message_text <- reactiveVal("")
  goal_message <- reactiveVal("")
  
  # SAVE ALL DATA LOCALLY
  save_all <- function() {
    saveRDS(
      list(
        activities = activities(),
        goals = goals()
      ),
      data_file
    )
  }
  
  # GET SELECTED DAY
  today_record <- reactive({
    d <- activities()
    
    if (nrow(d) == 0) return(NULL)
    
    idx <- which(d$date == as.Date(input$activity_date))
    
    if (length(idx) == 0) return(NULL)
    
    d[idx[length(idx)], , drop = FALSE]
  })
  
  # ----------------------------------------------------------
  # CALCULATE PRODUCTIVITY SCORE
  # ----------------------------------------------------------
  
  calculate_productivity <- function(d) {
    
    if (is.null(d)) return(0)
    
    study_score <- min(d$study / 4, 1) * 35
    work_score <- min(d$work / 4, 1) * 15
    sleep_score <- if (d$sleep >= 7 && d$sleep <= 9) 20 else
      if (d$sleep >= 6) 12 else 5
    exercise_score <- min(d$exercise / 30, 1) * 15
    mood_score <- d$mood * 1.5
    
    round(
      min(
        100,
        study_score + work_score + sleep_score +
          exercise_score + mood_score
      )
    )
  }
  
  calculate_wellbeing <- function(d) {
    
    if (is.null(d)) return(0)
    
    sleep_part <- if (d$sleep >= 7 && d$sleep <= 9) 40 else
      if (d$sleep >= 6) 25 else 10
    
    exercise_part <- min(d$exercise / 30, 1) * 20
    mood_part <- d$mood * 3
    stress_part <- (10 - d$stress) * 1.5
    
    round(
      min(
        100,
        max(
          0,
          sleep_part + exercise_part + mood_part + stress_part
        )
      )
    )
  }
  
  # ----------------------------------------------------------
  # SAVE ACTIVITY
  # ----------------------------------------------------------
  
  observeEvent(input$save_activity, {
    
    req(input$activity_date)
    
    values <- c(
      input$study_hours,
      input$work_hours,
      input$sleep_hours,
      input$exercise_minutes,
      input$screen_hours,
      input$mood_score,
      input$stress_score
    )
    
    req(all(is.finite(values)))
    req(all(values >= 0))
    req(input$mood_score <= 10)
    req(input$stress_score <= 10)
    
    d <- activities()
    selected_date <- as.Date(input$activity_date)
    
    # Replace existing entry for the selected date
    d <- d[d$date != selected_date, , drop = FALSE]
    
    new_row <- data.frame(
      date = selected_date,
      study = input$study_hours,
      work = input$work_hours,
      sleep = input$sleep_hours,
      exercise = input$exercise_minutes,
      screen = input$screen_hours,
      mood = as.integer(input$mood_score),
      stress = as.integer(input$stress_score),
      notes = input$day_notes %||% ""
    )
    
    d <- rbind(d, new_row)
    d <- d[order(d$date), , drop = FALSE]
    
    activities(d)
    save_all()
    
    message_text("Daily activity saved successfully!")
    
    showNotification(
      "Your activity has been saved.",
      type = "message"
    )
  })
  
  output$save_message <- renderUI({
    if (nzchar(message_text())) {
      div(class = "suggestion", message_text())
    }
  })
  
  # ----------------------------------------------------------
  # DAILY OVERVIEW
  # ----------------------------------------------------------
  
  output$today_overview <- renderUI({
    
    d <- today_record()
    
    if (is.null(d)) {
      return(
        p("Save an activity entry to see your daily overview.")
      )
    }
    
    tagList(
      h4(paste("Productivity:", calculate_productivity(d), "/100")),
      p(paste("Study:", d$study, "hours")),
      p(paste("Work:", d$work, "hours")),
      p(paste("Sleep:", d$sleep, "hours")),
      p(paste("Exercise:", d$exercise, "minutes")),
      p(paste("Screen time:", d$screen, "hours")),
      p(paste("Mood:", d$mood, "/10")),
      p(paste("Stress:", d$stress, "/10"))
    )
  })
  
  # ----------------------------------------------------------
  # ANALYZER METRICS
  # ----------------------------------------------------------
  
  output$productivity_score <- renderText({
    calculate_productivity(today_record())
  })
  
  output$wellbeing_score <- renderText({
    calculate_wellbeing(today_record())
  })
  
  output$mood_display <- renderText({
    d <- today_record()
    if (is.null(d)) "--" else d$mood
  })
  
  output$sleep_display <- renderText({
    d <- today_record()
    if (is.null(d)) "--" else d$sleep
  })
  
  output$analysis_text <- renderUI({
    
    d <- today_record()
    
    if (is.null(d)) {
      return(
        p("Record your activities first to generate your personal analysis.")
      )
    }
    
    score <- calculate_productivity(d)
    wellbeing <- calculate_wellbeing(d)
    
    status <- if (score >= 75) {
      "You had a productive day."
    } else if (score >= 50) {
      "You made progress, with room to improve."
    } else {
      "Focus on one or two manageable priorities tomorrow."
    }
    
    wellbeing_status <- if (wellbeing >= 75) {
      "Your recorded wellbeing indicators look encouraging."
    } else if (wellbeing >= 50) {
      "Consider giving more attention to your rest and routine."
    } else {
      "Consider making rest and manageable activities a priority."
    }
    
    tagList(
      h4(status),
      p(wellbeing_status),
      p(paste("Study and work hours:", d$study + d$work)),
      p(paste("Screen time recorded:", d$screen, "hours")),
      p(paste("Notes:", ifelse(nzchar(d$notes), d$notes, "No notes entered."))),
      p(
        class = "small-text",
        "These are rule-based estimates from your entries, not a clinical or validated psychological assessment."
      )
    )
  })
  
  # ----------------------------------------------------------
  # PERSONALIZED SUGGESTIONS
  # ----------------------------------------------------------
  
  output$suggestions <- renderUI({
    
    d <- today_record()
    
    if (is.null(d)) {
      return(p("Save your daily activity to receive suggestions."))
    }
    
    suggestions <- character()
    
    if (d$sleep < 7) {
      suggestions <- c(
        suggestions,
        "Sleep: consider a consistent bedtime and enough time for rest."
      )
    }
    
    if (d$study < 2) {
      suggestions <- c(
        suggestions,
        "Learning: try one focused 25-minute study session."
      )
    }
    
    if (d$exercise < 20) {
      suggestions <- c(
        suggestions,
        "Movement: consider a short walk or gentle movement break."
      )
    }
    
    if (d$screen > 5) {
      suggestions <- c(
        suggestions,
        "Screen time: review optional screen use and take regular breaks."
      )
    }
    
    if (d$stress >= 7) {
      suggestions <- c(
        suggestions,
        "Stress: pause, breathe slowly, and break your next task into smaller steps."
      )
    }
    
    if (d$mood <= 4) {
      suggestions <- c(
        suggestions,
        "Mood: consider a relaxing activity or talking with someone you trust."
      )
    }
    
    if (length(suggestions) == 0) {
      suggestions <- c(
        "Your recorded routine looks balanced today. Keep choosing manageable, repeatable habits.",
        "Reflection: write down one thing that went well today."
      )
    }
    
    tagList(
      lapply(suggestions, function(s) {
        div(class = "suggestion", s)
      })
    )
  })
  
  # ----------------------------------------------------------
  # ACTIVITY CHART
  # ----------------------------------------------------------
  
  output$activity_chart <- renderPlot({
    
    d <- today_record()
    
    validate(
      need(!is.null(d), "Save an activity before viewing this chart.")
    )
    
    chart_data <- data.frame(
      Activity = c(
        "Study", "Work", "Sleep", "Exercise", "Screen"
      ),
      Hours = c(
        d$study,
        d$work,
        d$sleep,
        d$exercise / 60,
        d$screen
      )
    )
    
    ggplot(
      chart_data,
      aes(
        x = reorder(Activity, Hours),
        y = Hours,
        fill = Activity
      )
    ) +
      geom_col(show.legend = FALSE, width = 0.7) +
      coord_flip() +
      labs(x = NULL, y = "Hours") +
      theme_minimal(base_size = 13)
  })
  
  # ----------------------------------------------------------
  # GOALS
  # ----------------------------------------------------------
  
  observeEvent(input$add_goal, {
    
    req(nzchar(trimws(input$goal_name)))
    
    g <- goals()
    
    if (input$goal_name %in% g$goal) {
      goal_message("This goal already exists.")
      return()
    }
    
    g <- rbind(
      g,
      data.frame(
        goal = trimws(input$goal_name),
        category = input$goal_category,
        done = FALSE
      )
    )
    
    goals(g)
    save_all()
    
    goal_message("Goal added successfully.")
    
    updateTextInput(session, "goal_name", value = "")
  })
  
  output$goal_message <- renderUI({
    if (nzchar(goal_message())) {
      div(class = "suggestion", goal_message())
    }
  })
  
  output$goal_list <- renderUI({
    
    g <- goals()
    
    if (nrow(g) == 0) {
      return(p("No goals yet. Add your first goal."))
    }
    
    tagList(
      lapply(seq_len(nrow(g)), function(i) {
        
        checkboxInput(
          paste0("goal_", i),
          paste(
            if (g$done[i]) "Completed:" else "Goal:",
            g$goal[i],
            "-", g$category[i]
          ),
          value = g$done[i]
        )
      })
    )
  })
  
  # Track completion without rewarding repeated clicks
  observe({
    
    g <- goals()
    
    if (nrow(g) == 0) return()
    
    lapply(seq_len(nrow(g)), function(i) {
      
      local({
        index <- i
        
        observeEvent(input[[paste0("goal_", index)]], {
          
          current <- goals()
          
          if (index <= nrow(current)) {
            
            current$done[index] <-
              isTRUE(input[[paste0("goal_", index)]])
            
            goals(current)
            save_all()
          }
          
        }, ignoreInit = TRUE)
      })
    })
  })
  
  # ----------------------------------------------------------
  # PROGRESS REPORTS
  # ----------------------------------------------------------
  
  output$trend_chart <- renderPlot({
    
    d <- activities()
    
    validate(
      need(nrow(d) > 0, "Save activities on different days to see a trend.")
    )
    
    d$productivity <- vapply(
      seq_len(nrow(d)),
      function(i) {
        calculate_productivity(d[i, , drop = FALSE])
      },
      numeric(1)
    )
    
    ggplot(d, aes(x = date, y = productivity)) +
      geom_line(color = "#7565ee", linewidth = 1) +
      geom_point(color = "#27b98a", size = 3) +
      scale_y_continuous(limits = c(0, 100)) +
      labs(x = "Date", y = "Productivity score") +
      theme_minimal(base_size = 13)
  })
  
  output$activity_table <- renderTable({
    
    d <- activities()
    
    if (nrow(d) == 0) return(data.frame(Message = "No activity recorded yet."))
    
    d$date <- as.character(d$date)
    
    names(d) <- c(
      "Date", "Study Hours", "Work Hours", "Sleep Hours",
      "Exercise Minutes", "Screen Hours", "Mood", "Stress", "Notes"
    )
    
    d
  })
  
  output$download_csv <- downloadHandler(
    
    filename = function() {
      paste0("mygrowth-activities-", Sys.Date(), ".csv")
    },
    
    content = function(file) {
      write.csv(activities(), file, row.names = FALSE)
    }
  )
  
  observeEvent(input$reload_data, {
    
    if (file.exists(data_file)) {
      
      latest <- readRDS(data_file)
      
      activities(latest$activities)
      goals(latest$goals)
      
      showNotification(
        "Saved data refreshed.",
        type = "message"
      )
    }
  })
}

shinyApp(ui, server)
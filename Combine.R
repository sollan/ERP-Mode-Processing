library(readr)

# Example: import -----------------------------------------------------------


PP13 <- read_delim("C:/Users/Annette/Desktop/Data/Log/NontonalMusician/PP13.txt", "\t", 
                   escape_double = FALSE, 
                   col_types = cols(Block = col_skip(), 
                                    Critical_onset = col_skip(), Event = col_skip(), 
                                    Onset = col_skip(), RT = col_number(), 
                                    Res_type = col_factor(levels = c("0", "1")),
                                    Response = col_factor(levels = c("1", "2")), 
                                    Stim_type = col_factor(levels = c("major", "minor")), 
                                    Tempo = col_number(), 
                                    Tempo_type = col_factor(levels = c("fast", "slow")), 
                                    Trial = col_skip()),
                   trim_ws = TRUE, skip = 3)

# Import Nontonal Musician Data -------------------------------------------

setwd("C:/Users/Annette/Desktop/Data/Log/NontonalMusician") 
NontonalMusician.files <- list.files(pattern = ".txt")

for (i in 1:(length(NontonalMusician.files))){
  if (i == 1) {
  NM.data <- data.frame(NULL)
  }
  cur.file <- read_delim(NontonalMusician.files[i], "\t", 
                   escape_double = FALSE, 
                   col_types = cols(Block = col_skip(), 
                                    Critical_onset = col_skip(), Event = col_skip(), 
                                    Onset = col_skip(), RT = col_number(), 
                                    Res_type = col_factor(levels = c("0", "1")),
                                    Response = col_factor(levels = c("1", "2")), 
                                    Stim_type = col_factor(levels = c("major", "minor")), 
                                    Tempo = col_number(), 
                                    Tempo_type = col_factor(levels = c("fast", "slow")), 
                                    Trial = col_skip()),
                   trim_ws = TRUE, skip = 3)
  
  NM.data <- rbind(NM.data, cur.file)
}

#View(NM.data)
write.csv(NM.data, file = "C:/Users/Annette/Desktop/Data/Log/NM.csv")


# Import Tonal Musician Data -------------------------------------------

setwd("C:/Users/Annette/Desktop/Data/Log/TonalMusician") 
TonalMusician.files <- list.files(pattern = ".txt")

for (i in 1:(length(TonalMusician.files))){
  if (i == 1) {
    TM.data <- data.frame(NULL)
  }
  cur.file <- read_delim(TonalMusician.files[i], "\t", 
                         escape_double = FALSE, 
                         col_types = cols(Block = col_skip(), 
                                          Critical_onset = col_skip(), Event = col_skip(), 
                                          Onset = col_skip(), RT = col_number(), 
                                          Res_type = col_factor(levels = c("0", "1")),
                                          Response = col_factor(levels = c("1", "2")), 
                                          Stim_type = col_factor(levels = c("major", "minor")), 
                                          Tempo = col_number(), 
                                          Tempo_type = col_factor(levels = c("fast", "slow")), 
                                          Trial = col_skip()),
                         trim_ws = TRUE, skip = 3)
  
  TM.data <- rbind(TM.data, cur.file)
}

#View(TM.data)
write.csv(TM.data, file = "C:/Users/Annette/Desktop/Data/Log/TM.csv", row.names = FALSE)

# Import Tonal Nonmusician Data -------------------------------------------

setwd("C:/Users/Annette/Desktop/Data/Log/TonalNonmusician") 
TonalNonmusician.files <- list.files(pattern = ".txt")

for (i in 1:(length(TonalNonmusician.files))){
  if (i == 1) {
    TN.data <- data.frame(NULL)
  }
  cur.file <- read_delim(TonalNonmusician.files[i], "\t", 
                         escape_double = FALSE, 
                         col_types = cols(Block = col_skip(), 
                                          Critical_onset = col_skip(), Event = col_skip(), 
                                          Onset = col_skip(), RT = col_number(), 
                                          Res_type = col_factor(levels = c("0", "1")),
                                          Response = col_factor(levels = c("1", "2")), 
                                          Stim_type = col_factor(levels = c("major", "minor")), 
                                          Tempo = col_number(), 
                                          Tempo_type = col_factor(levels = c("fast", "slow")), 
                                          Trial = col_skip()),
                         trim_ws = TRUE, skip = 3)
  
  TN.data <- rbind(TN.data, cur.file)
}

#View(TN.data)
write.csv(TN.data, file = "C:/Users/Annette/Desktop/Data/Log/TN.csv", row.names = FALSE)

# Import Nontonal Musician Data -------------------------------------------

setwd("C:/Users/Annette/Desktop/Data/Log/NontonalNonmusician") 
NontonalNonmusician.files <- list.files(pattern = ".txt")

for (i in 1:(length(NontonalNonmusician.files))){
  if (i == 1) {
    NN.data <- data.frame(NULL)
  }
  cur.file <- read_delim(NontonalNonmusician.files[i], "\t", 
                         escape_double = FALSE, 
                         col_types = cols(Block = col_skip(), 
                                          Critical_onset = col_skip(), Event = col_skip(), 
                                          Onset = col_skip(), RT = col_number(), 
                                          Res_type = col_factor(levels = c("0", "1")),
                                          Response = col_factor(levels = c("1", "2")), 
                                          Stim_type = col_factor(levels = c("major", "minor")), 
                                          Tempo = col_number(), 
                                          Tempo_type = col_factor(levels = c("fast", "slow")), 
                                          Trial = col_skip()),
                         trim_ws = TRUE, skip = 3)
  
  NN.data <- rbind(NN.data, cur.file)
}

#View(NN.data)
write.csv(NN.data, file = "C:/Users/Annette/Desktop/Data/Log/NN.csv", row.names = FALSE)
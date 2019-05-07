# Start -------------------------------------------------------------------
library(readxl)
library(ggplot2)
library(graphics)
library(car)
library(nlme)
library(reshape)
library(gridExtra)
library(grid)
library(ggm)
library(stargazer)
library(ez)

# Chords (direct rating) ------------------------------------------------------------------
# Chords2 <- read_excel("C:/Users/Annette/Desktop/Analysis/Chords.xlsx", col_types = c("numeric", 
#                                                     "text", "text", "numeric", "text", "numeric", 
#                                                     "numeric", "numeric", "numeric", "text"))

Chords2 = read.delim("C:/Users/Annette/Desktop/Analysis/Chords_new.txt", header = TRUE)
Chords2 <- subset(Chords2, 
                  Chords2$Group == "NTM" | Chords2$Group == "TM" | Chords2$Group == "TNM" | Chords2$Group == "NTNM")
colnames(Chords2)[7] <- "Emotions"
colnames(Chords2)[8] <- "Tone"
agg.chords <- aggregate(Chords2, list(Chords2$Pitch, Chords2$Tone), mean)
summary(agg.chords)
sd(agg.chords$Emotions)
minor <- subset(agg.chords, agg.chords$Tone == 0)
major <- subset(agg.chords, agg.chords$Tone == 1)
agg.comp.chords <- aggregate(Chords2, list(Chords2$Pitch, Chords2$Tone, 
                                           Chords2$Group), mean)

comp.chords.plot <- ggplot(minor)

comp.chords.plot + geom_point(aes(Pitch, minor$Emotions), colour = "red",
                              show.legend = TRUE) +
   geom_smooth(aes(Pitch, minor$Emotions), method = "lm",
               colour = "red", se = F) +
   geom_point(data = major, aes(Pitch, major$Emotions), colour = "blue",
              show.legend = TRUE) +
   geom_smooth(data = major, aes(Pitch, major$Emotions), method = "lm",
               colour = "blue", se = F) +
   ylim(1,4) + xlab("Fundamental frequency of root note in chord (Hz)") + ylab("Ratings (1 = sad, 4 = happy)") +
   ggtitle("Chord ratings", subtitle = "Ratings for minor (in red) and major (in blue) triads")

# Group comparisons -------------------------------------------------------


musician <- subset(Chords2, Chords2$Group == 'TM' | Chords2$Group == 'NTM')
nonmusician <- subset(Chords2, Chords2$Group == 'NTNM' | Chords2$Group == 'TNM')
tonal <- subset(Chords2, Chords2$Group == 'TM' | Chords2$Group == 'TNM')
nontonal <- subset(Chords2, Chords2$Group == 'NTM' | Chords2$Group == 'NTNM')

nontonalmusician <- subset(Chords2, Chords2$Group == 'NTM')
nontonalnonmusician <- subset(Chords2, Chords2$Group == 'NTNM')
tonalmusician <- subset(Chords2, Chords2$Group == 'TM')
tonalnonmusician <- subset(Chords2, Chords2$Group == 'TNM')

agg.chords.m <- aggregate(musician, list(musician$Pitch, musician$Tone), mean)
summary(agg.chords.m)

agg.chords.nm <- aggregate(nonmusician, list(nonmusician$Pitch, nonmusician$Tone), mean)
summary(agg.chords.nm)

agg.chords.t <- aggregate(tonal, list(tonal$Pitch, tonal$Tone), mean)
summary(agg.chords.t)

agg.chords.nt <- aggregate(nontonal, list(nontonal$Pitch, nontonal$Tone), mean)
summary(agg.chords.nt)

agg.chords.ntm <- aggregate(nontonalmusician, list(nontonalmusician$Pitch, nontonalmusician$Tone), mean)
summary(agg.chords.ntm)

agg.chords.ntnm <- aggregate(nontonalnonmusician, list(nontonalnonmusician$Pitch, nontonalnonmusician$Tone), mean)
summary(agg.chords.ntnm)

agg.chords.tm <- aggregate(tonalmusician, list(tonalmusician$Pitch, tonalmusician$Tone), mean)
summary(agg.chords.tm)

agg.chords.tnm <- aggregate(tonalnonmusician, list(tonalnonmusician$Pitch, tonalnonmusician$Tone), mean)
summary(agg.chords.tnm)


# Mixed ANOVA -------------------------------------------------------------

# Have you tried a mixed ANOVA with M/NM and T/NT as between factors 
# and major/minor as within factor as well as pitch as covariate?

Chords2$Language[Chords2$Group == "TM" | Chords2$Group == "TNM"] <- "Tonal"
Chords2$Language[Chords2$Group == "NTM" | Chords2$Group == "NTNM"] <- "Intonation"
Chords2$Music[Chords2$Group == "TM" | Chords2$Group == "NTM"] <- "Musician"
Chords2$Music[Chords2$Group == "NTNM" | Chords2$Group == "TNM"] <- "Nonmusician"

Chords_update <- write.csv(Chords2, file = "C:/Users/Annette/Desktop/Analysis/Chords_update.csv")


Chords_update <- read.csv("C:/Users/Annette/Desktop/Analysis/Chords_update.csv", header = TRUE)

library(lme4)

mod.tone.null <- lmer(formula = Emotions ~ Music * Language + (1|Pitch) + (1|id),
                      data = Chords_update, REML = FALSE)
mod.tone <- lmer(formula = Emotions ~ Music * Language + Tone + (1|Pitch) + (1|id),
               data = Chords_update, REML = FALSE)
mod.pitch.null <- lmer(formula = Emotions ~ Music * Language + (1|Tone) + (1|id),
                      data = Chords_update, REML = FALSE)
mod.pitch <- lmer(formula = Emotions ~ Music * Language + Pitch + (1|Tone) + (1|id),
                     data = Chords_update, REML = FALSE)
summary(mod.tone)
anova(mod.tone.null,mod.tone)
summary(mod.pitch)
anova(mod.pitch.null,mod.pitch)


# Correlation & LR for musical & language experience ----------------------


################### MUSICIANS ######################

minor.m <- subset(agg.chords.m, agg.chords.m$Tone == 0)
major.m <- subset(agg.chords.m, agg.chords.m$Tone == 1)
agg.comp.chords.m <- aggregate(musician, list(musician$Pitch, musician$Tone, 
                                           musician$Group), mean)
comp.chords.m <- matrix(c(agg.comp.chords.m$Emotions, 
                        agg.comp.chords.m$Tone,
                        agg.comp.chords.m$Pitch), ncol = 3, byrow = F, 
                      dimnames = list(c(1:96), c("Emotions","Tone","Pitch")))

regression.m <- lm(formula = Emotions ~ Tone + Pitch, data = as.data.frame(comp.chords.m))
s.regression.m <- step(regression.m)
cor(as.data.frame(comp.chords.m)$Tone, as.data.frame(comp.chords.m)$Emotions)
cor(as.data.frame(comp.chords.m)$Pitch, as.data.frame(comp.chords.m)$Emotions)

summary(s.regression.m)

################### NON-MUSICIANS ######################

minor.nm <- subset(agg.chords.nm, agg.chords.nm$Tone == 0)
major.nm <- subset(agg.chords.nm, agg.chords.nm$Tone == 1)
agg.comp.chords.nm <- aggregate(nonmusician, list(nonmusician$Pitch, nonmusician$Tone, 
                                              nonmusician$Group), mean)
comp.chords.nm <- matrix(c(agg.comp.chords.nm$Emotions, 
                          agg.comp.chords.nm$Tone,
                          agg.comp.chords.nm$Pitch), ncol = 3, byrow = F, 
                        dimnames = list(c(1:96), c("Emotions","Tone","Pitch")))

regression.nm <- lm(formula = Emotions ~ Tone + Pitch, data = as.data.frame(comp.chords.nm))
s.regression.nm <- step(regression.nm)
cor(as.data.frame(comp.chords.nm)$Tone, as.data.frame(comp.chords.nm)$Emotions)
cor(as.data.frame(comp.chords.nm)$Pitch, as.data.frame(comp.chords.nm)$Emotions)

summary(s.regression.nm)

################### TONAL ######################

minor.t <- subset(agg.chords.t, agg.chords.t$Tone == 0)
major.t <- subset(agg.chords.t, agg.chords.t$Tone == 1)
agg.comp.chords.t <- aggregate(tonal, list(tonal$Pitch, tonal$Tone, 
                                                  tonal$Group), mean)
comp.chords.t <- matrix(c(agg.comp.chords.t$Emotions, 
                           agg.comp.chords.t$Tone,
                           agg.comp.chords.t$Pitch), ncol = 3, byrow = F, 
                         dimnames = list(c(1:96), c("Emotions","Tone","Pitch")))

regression.t <- lm(formula = Emotions ~ Tone + Pitch, data = as.data.frame(comp.chords.t))
s.regression.t <- step(regression.t)
cor(as.data.frame(comp.chords.t)$Tone, as.data.frame(comp.chords.t)$Emotions)
cor(as.data.frame(comp.chords.t)$Pitch, as.data.frame(comp.chords.t)$Emotions)

summary(s.regression.t)

################### NONTONAL ######################

minor.nt <- subset(agg.chords.nt, agg.chords.nt$Tone == 0)
major.nt <- subset(agg.chords.nt, agg.chords.nt$Tone == 1)
agg.comp.chords.nt <- aggregate(nontonal, list(nontonal$Pitch, nontonal$Tone, 
                                           nontonal$Group), mean)
comp.chords.nt <- matrix(c(agg.comp.chords.nt$Emotions, 
                          agg.comp.chords.nt$Tone,
                          agg.comp.chords.nt$Pitch), ncol = 3, byrow = F, 
                        dimnames = list(c(1:96), c("Emotions","Tone","Pitch")))

regression.nt <- lm(formula = Emotions ~ Tone + Pitch, data = as.data.frame(comp.chords.nt))
s.regression.nt <- step(regression.nt)
cor(as.data.frame(comp.chords.nt)$Tone, as.data.frame(comp.chords.nt)$Emotions)
cor(as.data.frame(comp.chords.nt)$Pitch, as.data.frame(comp.chords.nt)$Emotions)

summary(s.regression.nt)


# Correlation & LR for each group -----------------------------------------


################### NONTONAL MUSICIANS ######################

minor.ntm <- subset(agg.chords.ntm, agg.chords.ntm$Tone == 0)
major.ntm <- subset(agg.chords.ntm, agg.chords.ntm$Tone == 1)
agg.comp.chords.ntm <- aggregate(nontonalmusician, list(nontonalmusician$Pitch, nontonalmusician$Tone, 
                                              nontonalmusician$Group), mean)
comp.chords.ntm <- matrix(c(agg.comp.chords.ntm$Emotions, 
                          agg.comp.chords.ntm$Tone,
                          agg.comp.chords.ntm$Pitch), ncol = 3, byrow = F, 
                        dimnames = list(c(1:48), c("Emotions","Tone","Pitch")))

regression.ntm <- lm(formula = Emotions ~ Tone + Pitch, data = as.data.frame(comp.chords.ntm))
s.regression.ntm <- step(regression.ntm)
cor(as.data.frame(comp.chords.ntm)$Tone, as.data.frame(comp.chords.ntm)$Emotions)
cor(as.data.frame(comp.chords.ntm)$Pitch, as.data.frame(comp.chords.ntm)$Emotions)
pcor.ntm <- pcor(c("Emotions", "Tone", "Pitch"), var(comp.chords.ntm))
pcor.ntm
pcor.ntm^2
pcor.test(pcor.ntm,1,16)

summary(s.regression.ntm)


################### NONTONAL NON-MUSICIANS ######################

minor.ntnm <- subset(agg.chords.ntnm, agg.chords.ntnm$Tone == 0)
major.ntnm <- subset(agg.chords.ntnm, agg.chords.ntnm$Tone == 1)
agg.comp.chords.ntnm <- aggregate(nontonalnonmusician, 
                                  list(nontonalnonmusician$Pitch, nontonalnonmusician$Tone, 
                                                  nontonalnonmusician$Group), mean)
comp.chords.ntnm <- matrix(c(agg.comp.chords.ntnm$Emotions, 
                           agg.comp.chords.ntnm$Tone,
                           agg.comp.chords.ntnm$Pitch), ncol = 3, byrow = F, 
                         dimnames = list(c(1:48), c("Emotions","Tone","Pitch")))

regression.ntnm <- lm(formula = Emotions ~ Tone + Pitch, data = as.data.frame(comp.chords.ntnm))
s.regression.ntnm <- step(regression.ntnm)
cor(as.data.frame(comp.chords.ntnm)$Tone, as.data.frame(comp.chords.ntnm)$Emotions)
cor(as.data.frame(comp.chords.ntnm)$Pitch, as.data.frame(comp.chords.ntnm)$Emotions)
pcor.ntnm <- pcor(c("Emotions", "Tone", "Pitch"), var(comp.chords.ntnm))
pcor.ntnm
pcor.ntnm^2
pcor.test(pcor.ntnm,1,22)

summary(s.regression.ntnm)

################### TONAL MUSICIANS ######################

minor.tm <- subset(agg.chords.tm, agg.chords.tm$Tone == 0)
major.tm <- subset(agg.chords.tm, agg.chords.tm$Tone == 1)
agg.comp.chords.tm <- aggregate(tonalmusician, list(tonalmusician$Pitch, tonalmusician$Tone, 
                                           tonalmusician$Group), mean)
comp.chords.tm <- matrix(c(agg.comp.chords.tm$Emotions, 
                          agg.comp.chords.tm$Tone,
                          agg.comp.chords.tm$Pitch), ncol = 3, byrow = F, 
                        dimnames = list(c(1:48), c("Emotions","Tone","Pitch")))

regression.tm <- lm(formula = Emotions ~ Tone + Pitch, data = as.data.frame(comp.chords.tm))
s.regression.tm <- step(regression.tm)
cor(as.data.frame(comp.chords.tm)$Tone, as.data.frame(comp.chords.tm)$Emotions)
cor(as.data.frame(comp.chords.tm)$Pitch, as.data.frame(comp.chords.tm)$Emotions)
pcor.tm <- pcor(c("Emotions", "Tone", "Pitch"), var(comp.chords.tm))
pcor.tm
pcor.tm^2
pcor.test(pcor.tm,1,15)


summary(s.regression.tm)

################### TONAL NONMUSICIANS ######################

minor.tnm <- subset(agg.chords.tnm, agg.chords.tnm$Tone == 0)
major.tnm <- subset(agg.chords.tnm, agg.chords.tnm$Tone == 1)
agg.comp.chords.tnm <- aggregate(tonalnonmusician, list(tonalnonmusician$Pitch, tonalnonmusician$Tone, 
                                               tonalnonmusician$Group), mean)
comp.chords.tnm <- matrix(c(agg.comp.chords.tnm$Emotions, 
                           agg.comp.chords.tnm$Tone,
                           agg.comp.chords.tnm$Pitch), ncol = 3, byrow = F, 
                         dimnames = list(c(1:48), c("Emotions","Tone","Pitch")))

regression.tnm <- lm(formula = Emotions ~ Tone + Pitch, data = as.data.frame(comp.chords.tnm))
s.regression.tnm <- step(regression.tnm)
cor(as.data.frame(comp.chords.tnm)$Tone, as.data.frame(comp.chords.tnm)$Emotions)
cor(as.data.frame(comp.chords.tnm)$Pitch, as.data.frame(comp.chords.tnm)$Emotions)

pcor.tnm <- pcor(c("Emotions", "Tone", "Pitch"), var(comp.chords.tnm))
pcor.tnm
pcor.tnm^2
pcor.test(pcor.tnm,1,17)

summary(s.regression.tnm)


# Plot by 4 groups --------------------------------------------------------



### NONTONAL MUSICIANS

comp.chords.plot.group1 <- ggplot(minor.ntm)

plot1 <- comp.chords.plot.group1 + geom_point(aes(Pitch, minor.ntm$Emotions), 
                                              colour = "black",
                              show.legend = TRUE) +
  geom_smooth(aes(Pitch, minor.ntm$Emotions), method = "lm",
              colour = "black", 
              linetype = "dashed", se = F) +
  geom_point(data = major.ntm, aes(Pitch, major.ntm$Emotions), 
             colour = "gray55",
             show.legend = TRUE) +
  geom_smooth(data = major.ntm, aes(Pitch, major.ntm$Emotions), method = "lm",
              colour = "gray55", 
              se = F) +
  ylim(1,4) + ylab("Ratings") + xlab("Hz") +
  #xlab("Fundamental frequency of root note in chord (Hz)") + ylab("Ratings (1 = sad, 4 = happy)") +
  ggtitle("Intonation Musicians"
          #, subtitle = "Ratings for minor (in red) and major (in blue) triads"
          ) + theme_apa(x.font.size = 12, y.font.size = 12)

### NONTONAL NONMUSICIANS

comp.chords.plot.group2 <- ggplot(minor.ntnm)

plot2 <- comp.chords.plot.group2 + geom_point(aes(Pitch, minor.ntnm$Emotions), colour = "black",
                                    show.legend = TRUE) +
  geom_smooth(aes(Pitch, minor.ntnm$Emotions), method = "lm",
              colour = "black", linetype = "dashed", se = F) +
  geom_point(data = major.ntnm, aes(Pitch, major.ntnm$Emotions), colour = "gray55",
             show.legend = TRUE) +
  geom_smooth(data = major.ntnm, aes(Pitch, major.ntnm$Emotions), method = "lm",
              colour = "gray55", se = F) +
  ylim(1,4) + ylab("Ratings") + xlab("Hz") +
  #xlab("Fundamental frequency of root note in chord (Hz)") + ylab("Ratings (1 = sad, 4 = happy)") +
  ggtitle("Intonation Nonmusicians"
          #, subtitle = "Ratings for minor (in red) and major (in blue) triads"
          ) +
  theme_apa(x.font.size = 12, y.font.size = 12)

### TONAL MUSICIANS

comp.chords.plot.group3 <- ggplot(minor.tm)

plot3 <- comp.chords.plot.group3 + geom_point(aes(Pitch, minor.tm$Emotions), colour = "black",
                                     show.legend = TRUE) +
  geom_smooth(aes(Pitch, minor.tm$Emotions), method = "lm",
              colour = "black", linetype = "dashed", se = F) +
  geom_point(data = major.tm, aes(Pitch, major.tm$Emotions), colour = "gray55",
             show.legend = TRUE) +
  geom_smooth(data = major.tm, aes(Pitch, major.tm$Emotions), method = "lm",
              colour = "gray55", se = F) +
  ylim(1,4) + ylab("Ratings") + xlab("Hz") +
  #xlab("Fundamental frequency of root note in chord (Hz)") + ylab("Ratings (1 = sad, 4 = happy)") +
  ggtitle("Tonal Musicians"
          #, subtitle = "Ratings for minor (in red) and major (in blue) triads"
          ) + 
  theme_apa(x.font.size = 12, y.font.size = 12)

### TONAL NONMUSICIANS

comp.chords.plot.group4 <- ggplot(minor.tnm)

plot4 <- comp.chords.plot.group4 + geom_point(aes(Pitch, minor.tnm$Emotions), colour = "black",
                                     show.legend = TRUE) +
  geom_smooth(aes(Pitch, minor.tnm$Emotions), method = "lm",
              colour = "black", linetype = "dashed", se = F) +
  geom_point(data = major.tnm, aes(Pitch, major.tnm$Emotions), colour = "gray55",
             show.legend = TRUE) +
  geom_smooth(data = major.tnm, aes(Pitch, major.tnm$Emotions), method = "lm",
              colour = "gray55", se = F) + 
  ylim(1,4) + ylab("Ratings") + xlab("Hz") +
  #xlab("Fundamental frequency of root note in chord (Hz)") + ylab("Ratings (1 = sad, 4 = happy)") +
  ggtitle("Tonal Nonmusicians"
          #, subtitle = "Ratings for minor (in red) and major (in blue) triads"
          ) +
  theme_apa(x.font.size = 12, y.font.size = 12)

### Arrange plots

grid.arrange(plot1, plot2, plot3, plot4, ncol=2)


# Distance between major & minor ------------------------------------------

agg.comp.chords.ntm.new <- read.csv("C:/Users/Annette/Desktop/Analysis/ntm.csv", header = TRUE)
agg.comp.chords.ntnm.new <- read.csv("C:/Users/Annette/Desktop/Analysis/ntnm.csv", header = TRUE)
agg.comp.chords.tm.new <- read.csv("C:/Users/Annette/Desktop/Analysis/tm.csv", header = TRUE)
agg.comp.chords.tnm.new <- read.csv("C:/Users/Annette/Desktop/Analysis/tnm.csv", header = TRUE)

comp.chords.plot.group1.new <- ggplot(agg.comp.chords.ntm.new)

plot1.new <- comp.chords.plot.group1.new + 
  geom_point(aes(agg.comp.chords.ntm.new$Pitch, agg.comp.chords.ntm.new$Distance), colour = "red",
             show.legend = TRUE) +
  geom_smooth(aes(agg.comp.chords.ntm.new$Pitch, agg.comp.chords.ntm.new$Distance), method = "lm",
              colour = "red", se = F) + ylim(-0.5,2) + xlab("Fundamental frequency of root note in chord (Hz)") + 
  ylab("Ratings (1 = sad, 4 = happy)") +
  ggtitle("Chord ratings (nontonal musician)", subtitle = "Ratings for minor (in red) and major (in blue) triads")

comp.chords.plot.group2.new <- ggplot(agg.comp.chords.ntnm.new)

plot2.new <- comp.chords.plot.group2.new + 
  geom_point(aes(agg.comp.chords.ntnm.new$Pitch, agg.comp.chords.ntnm.new$Distance), colour = "red",
             show.legend = TRUE) +
  geom_smooth(aes(agg.comp.chords.ntnm.new$Pitch, agg.comp.chords.ntnm.new$Distance), method = "lm",
              colour = "red", se = F) + ylim(-0.5,2) + xlab("Fundamental frequency of root note in chord (Hz)") + 
  ylab("Ratings (1 = sad, 4 = happy)") +
  ggtitle("Chord ratings (nontonal nonmusician)", subtitle = "Ratings for minor (in red) and major (in blue) triads")

comp.chords.plot.group3.new <- ggplot(agg.comp.chords.tm.new)

plot3.new <- comp.chords.plot.group3.new + 
  geom_point(aes(agg.comp.chords.tm.new$Pitch, agg.comp.chords.tm.new$Distance), colour = "red",
             show.legend = TRUE) +
  geom_smooth(aes(agg.comp.chords.tm.new$Pitch, agg.comp.chords.tm.new$Distance), method = "lm",
              colour = "red", se = F) + ylim(-0.5,2) + xlab("Fundamental frequency of root note in chord (Hz)") + 
  ylab("Ratings (1 = sad, 4 = happy)") +
  ggtitle("Chord ratings (tonal musician)", subtitle = "Ratings for minor (in red) and major (in blue) triads")

comp.chords.plot.group4.new <- ggplot(agg.comp.chords.tnm.new)

plot4.new <- comp.chords.plot.group4.new + 
  geom_point(aes(agg.comp.chords.tnm.new$Pitch, agg.comp.chords.tnm.new$Distance), colour = "red",
                                                      show.legend = TRUE) +
  geom_smooth(aes(agg.comp.chords.tnm.new$Pitch, agg.comp.chords.tnm.new$Distance), method = "lm",
              colour = "red", se = F) + ylim(-0.5,2) + xlab("Fundamental frequency of root note in chord (Hz)") + 
  ylab("Ratings (1 = sad, 4 = happy)") +
  ggtitle("Chord ratings (tonal nonmusician)", subtitle = "Ratings for minor (in red) and major (in blue) triads")

grid.arrange(plot1.new, plot2.new, plot3.new, plot4.new, ncol=2)



# Same plot ---------------------------------------------------------------


plot.total <- comp.chords.plot.group1.new + 
  geom_point(aes(agg.comp.chords.ntm.new$Pitch, agg.comp.chords.ntm.new$Distance), colour = "red",
             show.legend = TRUE) +
  geom_smooth(aes(agg.comp.chords.ntm.new$Pitch, agg.comp.chords.ntm.new$Distance), method = "lm",
              colour = "red", se = F) + 
  geom_point(aes(agg.comp.chords.ntnm.new$Pitch, agg.comp.chords.ntnm.new$Distance), colour = "blue",
             show.legend = TRUE) +
  geom_smooth(aes(agg.comp.chords.ntnm.new$Pitch, agg.comp.chords.ntnm.new$Distance), method = "lm",
              colour = "blue", se = F) + 
  geom_point(aes(agg.comp.chords.tm.new$Pitch, agg.comp.chords.tm.new$Distance), colour = "green",
             show.legend = TRUE) +
  geom_smooth(aes(agg.comp.chords.tm.new$Pitch, agg.comp.chords.tm.new$Distance), method = "lm",
              colour = "green", se = F) + 
  geom_point(aes(agg.comp.chords.tnm.new$Pitch, agg.comp.chords.tnm.new$Distance), colour = "black",
             show.legend = TRUE) +
  geom_smooth(aes(agg.comp.chords.tnm.new$Pitch, agg.comp.chords.tnm.new$Distance), method = "lm",
              colour = "black", se = F) + 
  ylim(-0.5,2) + xlab("Fundamental frequency of root note in chord (Hz)") + 
  ylab("Rating difference between major & minor triads") +
  ggtitle("Chord ratings", subtitle = "red: NTM; blue: NTNM; green: TM; black: TNM")

plot.total


# Analyze distance --------------------------------------------------------

model.ntm.new <- lm(formula = Distance ~ Pitch, data = as.data.frame(agg.comp.chords.ntm.new))
cor(as.data.frame(agg.comp.chords.ntm.new)$Pitch, as.data.frame(agg.comp.chords.ntm.new)$Distance)
summary(model.ntm.new)


model.ntnm.new <- lm(formula = Distance ~ Pitch, data = as.data.frame(agg.comp.chords.ntnm.new))
cor(as.data.frame(agg.comp.chords.ntnm.new)$Pitch, as.data.frame(agg.comp.chords.ntnm.new)$Distance)
regression.ntnm.new <- lm(formula = Distance ~ Pitch, data = as.data.frame(agg.comp.chords.ntnm.new))
summary(regression.ntnm.new)


model.tm.new <- lm(formula = Distance ~ Pitch, data = as.data.frame(agg.comp.chords.tm.new))
cor(as.data.frame(agg.comp.chords.tm.new)$Pitch, as.data.frame(agg.comp.chords.tm.new)$Distance)
summary(model.tm.new)


model.tnm.new <- lm(formula = Distance ~ Pitch, data = as.data.frame(agg.comp.chords.tnm.new))
cor(as.data.frame(agg.comp.chords.tnm.new)$Pitch, as.data.frame(agg.comp.chords.tnm.new)$Distance)
summary(model.tnm.new)


# Between-within repeated-measures ANOVA ----------------------------------

# Between factors: 
# IV: LANGUAGE, MUSIC
# Within factors:
# IV: MODE
# Repeated measure:
# IV: PITCH

# DV: EMOTION
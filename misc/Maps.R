#library(ggmap)
#library(rworldmap)

#resolution accepts "coarse", "low", "less islands", "li" and "high" (with
#additional package rworldxtra)
newMap <- getMap(resolution = "low")

#use source 'dsk'; 'google' is not available in China.
europe.limits <- geocode(c("CapeFligely,RudolfIsland,Franz Josef Land,Russia",
                           "Gavdos,Greece", "Faja Grande,Azores",
                           "SevernyIsland,Novaya Zemlya,Russia"),
                           source = 'dsk')

plot(newMap, xlim = range(europe.limits$lon),
             ylim = range(europe.limits$lat),
             asp = 1)

us.limits <- geocode(c("Northwest Angle, Lake of the Woods, Minnesota",
                       "Ballast Key, Florida", "Sail Rock, West Quoddy Head, Maine",
                       "Bodelteh Islands, Cape Alava, Washington"),
                       source = 'dsk')

plot(newMap, xlim = range(us.limits$lon),
             ylim = range(us.limits$lat),
             asp = 1)

#with rgdal and rgeos
lnd <- readOGR(dsn = "states_21basic", layer = "states") #load shp file
lnd <- lnd[lnd@data$STATE_ABBR != "AK", ] #Suppress Alaska
lnd <- lnd[lnd@data$STATE_ABBR != "HI", ] #Suppress Hawai
plot(lnd, col = "lightgray")
text(coordinates(gCentroid(lnd, byid = TRUE)), labels = lnd@data$STATE_ABBR, cex = 0.7)
mod.spt <- mod.proc[mod.proc$STATE %in% as.character(lnd$STATE_ABBR), ]
spm.nev <- mod.spt %>% group_by(STATE) %>% summarise(total.events = n())
rename(spm.nev, STATE_ABBR = STATE)
lnd@data <- merge(lnd@data, spm.nev, by = "STATE_ABBR", all = FALSE)
lnd_f <- fortify(lnd)
lnd$id <- row.names(lnd)
lnd_f <- left_join(lnd_f, lnd@data)
center <- as.data.frame(gCentroid(lnd, byid = TRUE))
center$STATE_ABBR <- lnd$STATE_ABBR


map <- ggplot(lnd_f, aes(long, lat, group = group, fill = events.average), alpha = 0.8) +
  geom_polygon() +
  geom_path(colour = "black", lwd = 0.05) +
  labs(title = "Number of Events Per State From 1950 to 2011") +
  theme_bw() +
  theme(axis.title = element_blank(), 
        axis.text = element_blank(), 
        axis.ticks = element_blank(), 
        axis.line = element_blank(), 
        panel.grid = element_blank()) +
  theme(legend.position = "bottom", legend.key.size = unit(1,"cm")) +
  scale_fill_gradient(name = "Number of Events", low = "yellow", high = "red") +
  annotate("text", label = center$STATE_ABBR, x = center$x, y = center$y)
map

tab.state <- as.data.frame(table(test$STATE_ABBR))
apply(tab.state, 1, function(x) {
  if (x[2] == 2) {
    test[test$STATE_ABBR == x[1], ]$x <<- test[test$STATE_ABBR == x[1], ]$x + c(-0.5, 0.5)
  }
  else if (x[2] == 3) {
    test[test$STATE_ABBR == x[1], ]$x <<- test[test$STATE_ABBR == x[1], ]$x + c(-1, 0, 1)
  }
})

# estimate mean of exponential lambda = 0.2 (mean = 5, sd = 5)
mns <- NULL
for (i in 1:1000) mns = c(mns, mean(rexp(40, 0.2)))
hist(mns)

# draw normal distribution (sd = s^2/n, namely 5^2/40)
n.x <- seq(2, 8, length = 40)
n.y <- dnorm(n.x, 5, 25/40)
plot(n.x, n.y, type = "line")

myplot <- function(s) {
  with(mtcars, plot(disp, mpg, type = "h"))
  abline(s, 0)
}
manipulate(myplot(s), s = slider(10, 30, step = 2.5))
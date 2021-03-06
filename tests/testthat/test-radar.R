context("Radar chart")
library(flipStandardCharts)

# Set up various data types to test
set.seed(1234)
unnamed <- abs(rnorm(10))
named <- structure(rpois(6, 20), .Names = c("Alpha", "Beta", "Gamma", "Delta", "Epsilon", "Zeta"))
negatives <- structure(rnorm(25), .Names = letters[1:25])
missing1 <- named
missing1[1] <- NA
single <- c(5)
double <- c(5, 1)
matrix2d <- cbind('Random values' = named, 'More random values' = rpois(6, 21))

# Create lists of all charting functions, data types and options to use
# Include relevant options from test-background.R and test-vectordata.R

dat.list <- c("unnamed", "named", "missing1","single", "double", "matrix2d")

opts <- c('default' = '',
          'datalabel' = 'data.label.show=TRUE, data.label.font.color="red", data.label.font.family="Courier"',
          'backgroundcolors' = 'background.fill.color="grey", background.fill.opacity=1, charting.area.fill.color="yellow", charting.area.fill.opacity=0.2',
          'grid' = 'x.grid.width=4, y.grid.width=1, y.tick.distance = 2, y.tick.font.size=8, y.tick.font.color="green"',
          'nogrid' = 'grid.show=FALSE, legend.show=FALSE, x.grid.width=1, y.grid.width=1',
          'ygrid' = 'y.grid.width = 0, data.label.show=TRUE, y.bounds.maximum = 5, x.tick.font.family="Arial Black", x.tick.font.size=16',
          
          'legendpos' = 'legend.position.y=0.5, legend.position.x=0, legend.font.color="red"',
          'legendbg' = 'legend.fill.color="blue", legend.fill.opacity=0.5, legend.border.color="red", legend.border.line.width=2',
          'margins' = 'margin.left=0, margin.right=0, margin.top=0, margin.inner.pad=10, charting.area.fill.color="red", charting.area.fill.opacity=1, legend.show=FALSE, grid.show=FALSE',
          'font' = 'global.font.family="Courier", global.font.color="red"',
          'nooutline' = 'line.thickness=0, x.tick.font.color="green"',
          'opacity' = 'opacity = 0.9',
          'modebar' = 'modebar.show = TRUE')


for (dat in dat.list)
{
    for (i in 1:length(opts))
    {
        # filestem is both the name of the image in accepted-snapshots
        # and the error msg expected on the output of devtools::test()
        filestem <- paste("radar", dat, names(opts)[i], sep="-")
        test_that(filestem, {
            
            cmd <- paste0("pp <- Radar(", dat, ",", opts[i], ")")
            if (grepl("missing|negative", filestem))
                expect_error(eval(parse(text=cmd)))
            else if (grepl("single|double", filestem))
                expect_warning(eval(parse(text=cmd)))
            else
            {
                expect_error(eval(parse(text=cmd)), NA)
                expect_true(TestWidget(pp, filestem))
                #print(pp)
                #readline(prompt=paste0(filestem, ": press [enter] to continue: "))
            }
        })
    }
}

test_that("Adjustable y.bounds.minimum",
{
    pp <- Radar(negatives)
    expect_true(TestWidget(pp, "radar-negatives"))
    
    pp <- Radar(negatives[1:5], y.bounds.maximum = -2, y.bounds.minimum = 2,
            data.label.show = TRUE, x.tick.show = FALSE, data.label.format = ".2f")
    expect_true(TestWidget(pp, "radar-negatives-labelformat"))
    
    pp <- Radar(negatives, y.bounds.minimum = 10)
    expect_true(TestWidget(pp, "radar-negatives-ymin"))
    
    pp <- Radar(negatives, y.bounds.maximum = 10)
    expect_true(TestWidget(pp, "radar-negatives-ymax"))
    
    expect_warning(pp<- SmallMultiples(matrix2d, "Radar", data.label.show = TRUE,
        y.bounds.minimum = "23", y.bounds.maximum = "12"),
        "Please specify a value outside [12, 26].", fixed = TRUE)
    expect_true(TestWidget(pp, "radar-smallmult-ybounds"))
})


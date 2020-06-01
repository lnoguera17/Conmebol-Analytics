
library(rvest)
reddit_wbpg <- read_html("https://www.reddit.com/r/politics/comments/a1j9xs/partisan_election_officials_are_inherently_unfair/")

reddit_wbpg %>%
  html_node("title") %>%
  html_text() 


reddit_wbpg %>%
  html_nodes("p.s90z9tc-10") %>%
  html_text()


# Let's scrape the time and URL of all latest pages published on Reddit's r/politics
reddit_political_news <- read_html("https://www.cnbc.com/fintech/")

my_nodes <- html_nodes(reddit_political_news,".desc") 

html_text(my_nodes, 'time')
time

html_attr(my_nodes, "href")



# Create a dataframe containing the URLs of the Reddit news pages and their published times
reddit_newspgs_times <- data.frame(NewsPage=urls, PublishedTime=time)
#Check the dimensions 
dim(reddit_newspgs_times)

# Filter dataframe by rows that contain a time published in minutes (i.e. within the hour)
reddit_recent_data <- reddit_newspgs_times[grep("minute|now", reddit_newspgs_times$PublishedTime),]
#Check the dimensions (# items will be less if not all pages were published within mins)
dim(reddit_recent_data)





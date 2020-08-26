# Soccer Data Analysis of South American Soccer Players

### Insipiration and Future Work

This project has been created solely for enjoyment and learning purposes, however, we believe that similar approaches can be performed at scale, capturing strong signals of a player's season, latest games played information and multiple data points beyond a soccer player's performance to automatically and effectively identify attractive buying opportunities during the transfer market window.

### Web Scraping 

Used the Rvest package to scrape SoFifa's website and collected data from more than 1,000 soccer players from South America. Data collected includes, overall player's rating, player's height, market value, best position in the field, ball control, dribbling, nationality and more.

### Exploration Data Analysis 

Wrangled, cleaned and visualized the scraped data using the Tidyverse ecosystem to generate and communicate quick insights. 

### Statistical Modeling

Fitted a base linear model to compare more poweful ones, pre-processed, resampled, fitted and evaluated linear models after multiple feature trasnformations and achieved *0.88 Adjusted R-Squared Error* and *~EU 4M RMSE* with a tuned Random Forest model. We used the Tidymodels ecosystem to understand drivers of the player's market value and provide an objective value estimation. 

### Dashboard and Model Deployment

Created a dashboard using Shinydashboards to provide users the ability to set new parameters for a new player and automatically estimate his market value. Also, the shinydashboard offer dynamic objects to visualize and provide information about the soccer players in the dataset. [Access the Shinyapp here](https://lnoguera.shinyapps.io/Conmebol-Analytics/)

### Collaboration Tools 

To keep track of the project scope, progress, stories and organization we used *Notion*, check out our notion page, [here](https://www.notion.so/luisnoguera/Soccer-Analytics-14ebe2427ce448a8884660d8291e4fdb). This proved to be an amazing all-in-one workspace that allowed us, the contributors, to stay focused an organized during the whole project. We also switched our project conversations, git and github activity to a Slack channel [Slack](https://slack.com/), this method we think, served as a great tool to keep up with new remote branches created and commits added. 

### Want to collaborate?

If you are looking to improve the statistical model or have creative ideas to incorporate in the dashboard, reach out to any of the contributors. Looking forward to connect and work together!

### To Barcelona fans, specially Nico Kaswalder 

![Barca 8-2](https://img-9gag-fun.9cache.com/photo/aBmL92A_700bwp.webp)


**Project Contributors:** 

[Luis Noguera](https://www.linkedin.com/in/luis-noguera/)

[Nicolas Kaswalder](https://www.linkedin.com/in/nicolas-kaswalder)

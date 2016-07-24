# beerwinners Team Project: Text Mining with Recipes

1. Load recipe data with r script "1.Recipe Scraping.R"
Note: In order to replicate our results and test our clusters, making iterative changes to our code for optimization purposes, we have decided to load the data set "RecipeData.RDA".  This can be used by anyone who wishes to duplicate our results exactly.
2. Use tm R package to create and clean corpus with "2.Recipe Corpus Clean.R"
Note: You can see more exploratory code with ingredients clean up in the r script "Recipe Ingredients Exploratory.R"
3. Next, we want to create clusters using the k-means method.  Run the next r script to complete this step, "3.K-means Recipe Clustering.R"
4. We run Naive Bayes on our clusters to see if the classification of our "flavor profiles" works well, run the next step "4.NB_kmeans.R"

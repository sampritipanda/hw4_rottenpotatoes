# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create! movie
  end
end

# Make sure that all the movies in the database are seen.
Then /^I should see all of the movies/ do
  assert Movie.all.size == page.all("table tr").size - 1
end

# Make sure that none of the movies in the database are seen.
Then /^I should see none of the movies/ do
  rows = page.all("table tr").size - 1
  assert rows == 0 || rows == 10
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  body = page.body
  assert body.index(e1) < body.index(e2)
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  if uncheck == "un"
    rating_list.split(', ').each { |r| step %{I uncheck "ratings_#{r}"} }
  else
    rating_list.split(', ').each { |r| step %{I check "ratings_#{r}"} }
  end
end

Then /the director of "(.*)" should be "(.*)"/ do |title, director|
  assert Movie.find_by_title(title).director == director 
end
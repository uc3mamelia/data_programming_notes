library(scrapex)
library(xml2)
library(magrittr)
library(purrr)
library(tibble)
library(tidyr)
library(readr)

# If this were being done on the real website of the newspaper, you'd want to
# replace the line below with the real link of the website.
newspaper_link <- elpais_newspaper_ex()
newspaper <- read_html(newspaper_link)

all_sections <-
  newspaper %>%
  # Find all <section> tags which have an <article> tag
  # below each <section> tag. Keep only the <article>
  # tags which an attribute @data-dtm-region.
  xml_find_all("//section[.//article][@data-dtm-region]")

final_df <-
  all_sections %>%
  # Count the number of articles for each section
  map(~ length(xml_find_all(.x, ".//article"))) %>%
  # Name all sections
  set_names(all_sections %>% xml_attr("data-dtm-region")) %>%
  # Convert to data frame
  enframe(name = "sections", value = "num_articles") %>%
  unnest(num_articles)

final_df

newspaper_link <- elpais_newspaper_ex()

all_sections <-
  newspaper_link |>
  read_html() |>
  xml_find_all("//section[.//article][@data-dtm-region]")

final_df <-
  all_sections |>
  map(~ length(xml_find_all(.x, ".//article"))) |>
  set_names(all_sections |> xml_attr("data-dtm-region")) |>
  enframe(name = "sections", value = "num_articles") |>
  unnest(num_articles)

# Save the current date time as a column
final_df$date_saved <- format(Sys.time(), "%Y-%m-%d %H:%M")

# Where the CSV will be saved. Note that this directory
# doesn't exist yet.
file_path <- "/Users/ameliabshuler/Desktop/data_programming_notes/data-harvesting/newspaper/newspaper_section_counter.csv"

# *Try* reading the file. If the file doesn't exist, this will silently save an error
res <- try(read_csv(file_path, show_col_types = FALSE), silent = TRUE)

# If the file doesn't exist
if (inherits(res, "try-error")) {
  # Save the data frame we scraped above
  print("File doesn't exist; Creating it")
  write_csv(final_df, file_path)
} else {
  # If the file was read successfully, append the
  # new rows and save the file again
  rbind(res, final_df) |> 
    write_csv(file_path)
}


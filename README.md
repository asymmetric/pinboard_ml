# desert-cache

## Endpoints

- `POST` /link
- `PUT` /link
- `GET` /tags
    - `GET` /tags?prefix=:prefix
    - `GET` /tags?sort=:sort
    - `GET` /tags/:id
- `GET` /link/:id
    - `GET` /link/:id/tags
- `GET` /links

## Types

- Link
    - `id`
    - `title`
    - `url`
    - `description`
    - `has_many tag`
        - in sqlite, this would mean storing storing a json array of tags under the link table
            - there would be no separate tags table
            - would be hard to list all tags, as we'd have to iterate over all the tags for each link, and get unique ones
        - or, i could store tags as simple rows in a row table, and then use foreign keys on the link
    - `date`
- Tag
    - `id`
    - `name`
    - `belongs_to link`
        - `link_id` ?

def insert_img(filename)
  odiv = %Q{<div style="text-align: center;">\n}
  brake = %Q{<br/>\n}
  img = %Q{<img src=\"images/#{filename}\" />\n}
  cdiv = %Q{</div>\n}
  snippet = odiv + brake + img + cdiv
  return snippet
end

module ActivityCategoriesHelper

#display the categories dynamically
def getactcategories(category)
	categ = ActivityCategory.find_by_category_name(category) if !category.nil?
	if !categ.nil? && !categ.category_file_name.nil? && !categ.category_file_name.blank? && categ.category.present? 
		catimage = categ.category.url(:large) if !categ.category.nil? && categ.category.present?
		cslug = categ.slug if categ && categ.slug
	else
		catimage = "/assets/quick_links/default.png"
		cslug = categ.slug if categ && categ.slug
	end
	return catimage,cslug
end

def getactsubcategories(subcate)
	subcat = ActivitySubcategory.find_by_subcateg_name(subcate) if !subcate.nil?
	if !subcat.nil? && !subcat.sub_category_file_name.nil? && !subcat.sub_category_file_name.blank? && subcat.sub_category.present? 
		catimage = subcat.sub_category.url(:large) if !subcat.sub_category.nil? && subcat.sub_category.present?
		sslug = subcat.slug if subcat && subcat.slug
	else
		catimage = "/assets/quick_links/default.png"
		sslug = subcat.slug if subcat && subcat.slug
	end
	return catimage,sslug
end

end

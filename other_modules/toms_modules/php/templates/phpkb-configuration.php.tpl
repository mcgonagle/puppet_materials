<?php

// $Id: phpkb-configuration.php.tpl,v 1.7 2009/05/18 20:35:17 rbraun Exp $
// Auto-generated for <%= fqdn %> by puppet

// WARNING: Do not make any changes directly in this file as it may make the 'PHPKB Knowledge Base System' to stop working properly.

// PHPKB Professional Status Settings 
$putdown_for_maintenance  = "no";


// PHPKB Professional's Admin(Superuser) Information 
$adminUsername = "<%= kb_admin %>";
$adminPassword = "<%= kb_pw %>";
$adminEmail = "<%= kb_email %>";
$adminFullname = "<%= kb_fullname %>";

// MySQL Database Settings 
$mySQLServer = "<%= kb_dbserver %>";
$mySQLUsername = "<%= kb_dbuser %>";
$mySQLPassword = "<%= kb_dbpass %>";
$mySQLDatabase = "<%= kb_dbname %>";

// PHPKB Professional (Knowledgebase) Settings 
$kbName = "<%= kb_sitename %>";
$kbSlogan = "<%= kb_slogan %>";
$path_kb = "<%= kb_siteurl %>";


// ------------------------------ Start of Feature Settings ---------------------------------- 

// Related to Comments 
$enable_question_comments = "no";
$auto_approve_comments = "no";
$comment_flood_control = "60";

// Related to Questions 
$enable_email_question = "no";
$enable_print_question = "no";
$enable_question_rating  = "no";
$enable_related_questions = "yes";
$enable_exportto_msword  = "no";
$enable_exportto_pdf  = "no";
$enable_bookmark_question  = "no";
$enable_delicious_bookmark  = "no";
$enable_digg_it  = "no";
$enable_furl_it  = "no";
$enable_subscribe_article  = "no";
$autolink_glossary_terms  = "no";
$enable_search_box  = "yes";
$enable_question_hits  = "no";
$enable_language_translation  = "no";

// Question's Email Settings
$email_question_subject  = "$template_subject";
$email_template = "$template_dear <- $template_name_of_your_friend ->,
		
	$template_body_desc1 <- $template_your_name -> (<- $template_your_email ->) $template_body_desc2 
	$template_body_desc3
		
	<u>$template_title</u>: <- $template_question_title_here ->
	<u>$template_link</u>: <- $template_url_of_question ->  
		
	$template_body_desc4
		
	$template_sincerely,
	<- $template_website_name ->";

// Related to Sign Up page
$enable_signup_page  = "no";

// Related to Glossary page
$enable_glossary_page  = "yes";

// Related to Contact page
$enable_contact_page  = "no";
$save_submitted_question  = "no";

// Related to RSS Feed
$enable_rss_feed  = "no";
$enable_rss_popular_feed  = "no";
$enable_rss_latest_feed  = "no";

// File Attachments - Settings
$max_file_size = "1024";

// ------------------------------ End of Feature Settings ---------------------------------- 


// Miscellaneous Settings
$use_wysiwyg_editor  = "yes";
$string_users = "PHPKB Knowledge Base v2.0";
$use_seo_urls  = "yes";
$search_results_perpage  = "10";

// Google Adsense Settings
$use_google_adsense  = "no";
$adsense_publisher_id  = "";
$adsense_channel_id  = "";
$google_ad_format  = "468x60_as";
$google_ad_width  = "468";
$google_ad_height  = "60";
$google_ad_type  = "text";
$google_color_border  = "";
$google_color_link  = "";
$google_color_url  = "";
$google_color_bg  = "";
$google_color_text  = "";
$google_ads_position  = "after";

// Entries Per Page (Admin Section)
$entries_perpage  = "10";


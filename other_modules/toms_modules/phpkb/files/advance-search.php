<?
error_reporting(0);

include('include/functions.php');
include('include/db-conn.php');
include('include/language.php'); //Script for Language Session Management

if($putdown_for_maintenance == "yes")
{
        header("Location:down-for-maintenance.php");
        exit();
}

$search_keyword = trim($_REQUEST[searchkeyword]); // Getting variable from Advance Search Page for Search Criteria

$patterns[0] = "/</";
$patterns[1] = "/>/";
$patterns[2] = "/on/";
$patterns[3] = "/script/";
$patterns[4] = "/alert/";

$replacements[0] = "&#60";
$replacements[1] = "&#62";
$replacements[2] = "&#111&#110";
$replacements[3] = "&#115&#99&#114&#105&#112&#116";
$replacements[4] = "&#97&#108&#101&#114&#116";

$new_patterns[0] = "/</";
$new_patterns[1] = "/>/";
$new_patterns[2] = "/'/";
$new_patterns[3] = "/)/";
$new_patterns[4] = "/(/";

$new_replacements[0] = "&lt;";
$new_replacements[1] = "&gt;";
$new_replacements[2] = "&apos;";
$new_replacements[3] = "&#x29;";
$new_replacements[4] = "&#x28;";

$search_keyword_to_display = preg_replace($patterns, $replacements, $search_keyword);

$_REQUEST[search_method] = preg_replace($new_patterns, $new_replacements, $_REQUEST[search_method]);
$search_method          = $_REQUEST[search_method];

$_REQUEST[search_in] = preg_replace($new_patterns, $new_replacements, $_REQUEST[search_in]);
$search_in_options      = $_REQUEST[search_in];

$category_id            = $_REQUEST[category];

if($_REQUEST[searchkeyword] != "")      { $get_usersearch_variables  = "&searchkeyword=$_REQUEST[searchkeyword]";            }
if($_REQUEST[search_method] != "")      { $get_usersearch_variables .= "&search_method=$_REQUEST[search_method]";            }
if($_REQUEST[search_in] != "")          { $get_usersearch_variables .= "&search_in=$_REQUEST[search_in]";                            }
if($_REQUEST[sort_results_by] == "latest")
{
        $get_usersearch_variables .= "&sort_results_by=latest";
        $sort_results_by        = "latest";
}
else
{
        $get_usersearch_variables .= "&sort_results_by=popularity";
        $sort_results_by        = "popularity";
}

if( $_REQUEST[category] != "" && $_REQUEST[category] != 0 && is_numeric($_REQUEST[category]) )
{
        $get_usersearch_variables .= "&category=$_REQUEST[category]";
}

// By Default Options are Checked
$search_method_any      = "selected";
$search_in_both         = "checked";
$sort_by_popularity = "checked";

if($category_id != 0 && is_numeric($_REQUEST[category]) )
{
        $category_id = $category_id; // To Display Selected category in Dropdown list-categories.php OR list-protected-categories.php
        $category_name = @mysql_result(@mysql_query("SELECT category_name FROM phpkbv1_categories WHERE category_id = $category_id"),0,0);
}
else
{
        $category_name = $search_all_categories_text;
}

$limit = $search_results_perpage; // limit variable getting from Configuration.php , We can fix the limit to see the Search Results( eg: 5/page or 10/page)  

if($_GET[from] != "")
{
        if(is_numeric($_GET[from]))
        {
                $startfrom = $_GET[from];
        }
        else
        {
                $startfrom = 0;
        }
}
else
{
        $startfrom = 0;
}

if($search_keyword != "")
{
        // For $search_method ......
        if($search_method != "Exact Match")
        {
                if($search_method == "All Words")
                { $and_or = "AND"; }
                else
                { $and_or = "OR"; }
                 
                $search_words = split(" ",$search_keyword);
                for ($i=0; $i<count($search_words); $i++)
                {
                        // For  $search_in_query
                        if($search_in_options == "Question Title")
                        { $search_in_query .= "question_title LIKE '%$search_words[$i]%'  $and_or ";         $search_in_title="checked";}
                        elseif($search_in_options == "Question Description")
                        {       $search_in_query .= "question_content LIKE '%$search_words[$i]%'  $and_or ";         $search_in_description="checked"; }
                        else
                        {       $search_in_query .= "(question_title LIKE '%$search_words[$i]%' OR question_content LIKE '%$search_words[$i]%')  $and_or "; $search_in_both="checked";    }
                }

                $search_in_query = substr($search_in_query, 0,-4);
                $search_in_query = "AND (".$search_in_query.")";
        }

        if($search_method == "All Words")
        {       $search_method_query = "LIKE '% $search_keyword %'";  $search_method_all="selected"; }
        elseif($search_method == "Exact Match")
        {       $search_method_query = "LIKE '$search_keyword'"; $search_method_exact="selected"; }
        else
        {   $search_method_query = "LIKE '%$search_keyword%'"; $search_method_any ="selected"; }

        // For  $search_in_query for  "Exact Match" .....
        if($search_method == "Exact Match")
        {
                if($search_in_options == "Question Title")
                {       $search_in_query = "AND question_title $search_method_query";        $search_in_title="checked"; }
                elseif($search_in_options == "Question Description")
                {       $search_in_query = "AND question_content $search_method_query"; $search_in_description="checked"; }
                else
                {       $search_in_query = "AND (question_title $search_method_query OR question_content $search_method_query)";  $search_in_both="checked"; }
        }

        // For $sort_by_query .....
        if($sort_results_by == 'latest') 
        {       $sort_by_query = "ORDER BY question_date desc";  $sort_by_latest = "checked";        }
        else 
        {       $sort_by_query = "ORDER BY question_hits desc";  $sort_by_popularity = "checked"; }

        //----------------------------------Small Portion of Queries Varies (variables) in Different Conditions---------------------
        if(($_SESSION[member_id_Session]!="")||($_SESSION[member_username_Session]!="" ))
        {  $hidden_query        = "(hidden = 0 OR hidden = 3)";  }else{  $hidden_query       = "(hidden = 0)";  }

        if($category_id != 0) { $category_id_query   = "AND phpkbv1_questions.category_id = $category_id";   }
        $from_where_main_query = "FROM phpkbv1_questions, phpkbv1_categories 
                                                                WHERE (phpkbv1_questions.category_id = phpkbv1_categories.category_id) AND
                                                                $hidden_query  $category_id_query  AND  question_status=0 
                                                                AND phpkbv1_questions.language_id = $_SESSION[browser_language] 
                                                                $search_in_query";

        $orderby_limit_query  = "$sort_by_query LIMIT $startfrom,$limit"; // Tale Part of Each Query
        //------------------------------------------------------------------------------------------------------------------------

        $search_query                   =  "SELECT question_id,author_id,question_title,question_content,question_hits,question_date,phpkbv1_questions.category_id,  phpkbv1_categories.category_id,hidden  $from_where_main_query  $orderby_limit_query";
        $total_search_results   =       @mysql_result(@mysql_query("SELECT Count(*) $from_where_main_query"),0,0);

        $search_results         =       @mysql_query($search_query,$connection) or Die("<b>Could not Execute the Query for Search Questions</b>");
        $num_search_results     =       @mysql_num_rows($search_results); // Number of Search Results Displayed on One Screen according to the Limit....

        $search_id      =       @mysql_result(@mysql_query("SELECT MAX(search_id) FROM phpkbv1_savedsearches"),0,0);
        $search_id++;

        if($total_search_results > 0 )
        {
                 // Successful Saved Searches for Administrator
                 $insert_save_search    =       @mysql_result(@mysql_query("INSERT INTO phpkbv1_savedsearches VALUES ( $search_id, $_SESSION[browser_language], '$search_keyword', 'Successful', now(), now())"),0,0);

                 while($record = @mysql_fetch_array($search_results))
                 { 
                        $question_content       = stripslashes(html_entity_decode($record[question_content]));
                        $question_content       = html2txt($question_content);
                        $question_content       = substr($question_content, 0, 200);

                        $category_name          = @mysql_result(@mysql_query("SELECT category_name FROM phpkbv1_categories WHERE category_id = $record[category_id]"),0,0);
                        $author_name            = @mysql_result(@mysql_query("SELECT author_name FROM phpkbv1_authors WHERE author_id = $record[author_id]"),0,0);

                        if(($_SESSION[member_id_Session]!="")||($_SESSION[member_username_Session]!="" ))
                        {
                                $protected_category_image = "";
                                if($record[hidden] == 3) // Protected Category
                                {
                                        $protected_category_image = "<img src=\"admin/images/lock.gif\" alt=\"Protected\" width=\"18\" height=\"18\" style=\"vertical-align: middle;\">";
                                } 
                         }
                         
                        if($use_seo_urls=="yes") // For SEO Friendly Static URLs
                        {
                                $question_link_string = "article-$record[question_id].html";
                        }
                        else
                        {
                                $question_link_string = "question.php?ID=$record[question_id]";
                        }

                        $display_results .= "<table width=\"740\" border=\"0\" align=\"center\" cellpadding=\"4\" cellspacing=\"0\" class=\"theme-text\">
                                                                        <tr><td colspan=\"3\">
                                                                                <strong> $search_title </strong> <a href=\"$question_link_string\"><b>$record[question_title]</b></a> $search_in $protected_category_image <strong> $category_name </strong></td></tr>
                                                                        <tr><td colspan=\"3\" align=\"justify\">$question_content ... <span><a href=\"$question_link_string\" title=\"Click for Full View\">$search_read_more_text</a></span></td></tr>
                                                                        <tr>
                                                                                <td>$search_author_text $author_name </td>
                                                                                <td>$search_created_on_text ".date_convert($record[question_date],1)."</td>
                                                                                <td>$search_accessed_text $record[question_hits] $search_times_text  </td>
                                                                        </tr>
                                                                        <tr><td colspan=\"3\"><hr noshade size=\"1\"></td></tr>
                                                                </table>";
                 }
        }
        else
        {
                if($search_in_options == "Question Title") { $search_in_options_text = $advance_option_qt; }
                elseif($search_in_options == "Question Description") { $search_in_options_text = $advance_option_qd; }
                else{ $search_in_options_text = $advance_option_both; }

                $total_search_results = 0;

                // Failed Saved Searches for Administrator
                $insert_save_search     =       @mysql_result(@mysql_query("INSERT INTO phpkbv1_savedsearches VALUES ( $search_id, $_SESSION[browser_language], '$search_keyword', 'Failed', now(), now())"),0,0);

                $display_results .= "<table width=\"740\" border=\"0\" align=\"center\" cellpadding=\"4\" cellspacing=\"0\" class=\"theme-text\">
                <tr>
                <td height=\"40\" style=\"padding-left:15pt;\">
                <b>$advance_record_not_found_desc1 \"$search_keyword_to_display\" $search_in \"$search_in_options_text\" $advance_record_not_found_desc2 \"$category_name\" $advance_record_not_found_desc3.</b>
                <br><br>
                <u>$advance_suggestions_text</u>:
                <ul>
                <li>$advance_check_spelling_text</li>
                <li>$advance_less_general_words_text</li>
                <li>$advance_different_words_text</li>
                </ul><br>
                </td>
                </tr>
                </table>";
        }

         $result_status_bar = "<tr bgcolor=\"#FFF4E6\"> 
                                                                        <td class=\"section-title\"><img src=\"images/articles-theme.gif\" width=\"25\" height=\"28\" style=\"vertical-align: middle;\"> 
                                                                          $total_search_results  $search_records_found_title </td>
                                                                        <td align=\"right\" width=\"500\" class=\"section-title\"> <span style=\"font:normal;\">$message_display_results </span>&nbsp;&nbsp</td>
                                                        </tr>";
}
?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Search Results - <? print $kbName; ?></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="description" content="PHPKB is an Online Knowledge Base Software to reduce your workload and provide quick customer support to your website visitors.">
<meta name="keywords" content="phpkb, Knowledge Base Script, Knowledge Base Software, Knowledge Base System, Knowledge Base Management, Knowledgebase Script, Knowledgebase Software, Article Directory Script, PHP FAQ Software, FAQ Builder Script, Technical Support Software">
<meta name="generator" content="PHPKB Knowledge Base Script">
<meta name="pragma" content="no-cache">
<!-- Knowledgebase Powered by 'PHPKB Knowledge Base Script' (http://www.knowledgebase-script.com) -->
<!-- Please do not remove this line from the code to keep the license valid -->
<link href="phpkb.css" rel="stylesheet" type="text/css">
</head>
<body bgcolor="#052868" style="margin: 0">
<table width="760" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#252B37" class="theme-text">
 <tr>
                <!-- page logo.php -->
                <? include('include/logo.php');?>
 </tr>
 <tr> 
    <td height="30" align="left" style="background-image:url(images/menuback-grey.gif)" class="white-text">
                <img src="images/corner.gif" alt="" width="14" height="30" style="vertical-align: middle;"> 
        <? print stripslashes($kbName)." ".$language_name_title; ?><br>
        </td>
    <td height="30" align="right" style="background-image:url(images/menuback-grey.gif)" class="white-text">
                 <? print stripslashes($kbSlogan); ?>&nbsp;&nbsp;

        </td>
  </tr>
        </table>
        <table width="760" align="center" border="0"  style="border: solid 1px #596884" cellpadding="0" bgcolor="#252B37" cellspacing="0" class="theme-text">
  <tr> 
                <!-- page links-topbar.php  -->
                <? include('include/links-topbar.php');?>
  </tr>
  <tr <? print $dir; ?>> 
    <td colspan="2" class="section-title"><img src="images/search-theme.gif" alt="Search Knowledge Base" width="25" height="28" style="vertical-align: middle;"> 
      <strong><? print $advance_search_title; ?> </strong></td>
  </tr>
  <tr <? print $dir; ?>> 
    <td height="40" colspan="2" class="theme-text" style="padding-left:10pt;padding-right:10pt;"><? print $advance_search_desc; ?></td>
  </tr>
  <tr> 
    <td colspan="2">&nbsp;</td>
  </tr>
  <tr <? print $dir; ?>> 
    <td colspan="2" style="padding-left:10pt;padding-right:10pt;"> 
                <form name="form1" method="post" action="advance-search.php">
        <table width="720" border="0" cellpadding="4" cellspacing="0" class="theme-text">
          <tr> 
                                <td width="165" align="right">&nbsp; <? print $advance_type_keyword_text; ?></td>
                                <td width="579">&nbsp;&nbsp;<input name="searchkeyword" type="text" value="<? print stripslashes($search_keyword_to_display); ?>" size="30"></td>
                          </tr>
                          <tr> 
                                <td valign="top" align="right">&nbsp; <? print $advance_use_search_method; ?> </td>
                                <td>&nbsp;
                                        <select name="search_method" size="1" id="search_method">
                                          <option value="Any Word" <? print $search_method_any; ?>> <? print $advance_option_anyword; ?> </option>
                                          <option value="All Words" <? print $search_method_all; ?>> <? print $advance_option_allwords; ?> </option>
                                          <option value="Exact Match" <? print $search_method_exact; ?>> <? print $advance_option_exactmatch; ?> </option>
                                        </select>
                                </td>
                          </tr>

                          <tr> 
                                <td valign="top" align="right">&nbsp; <? print $advance_search_in_text; ?> </td>
                                <td>
                                        <input type="radio" name="search_in" value="Both" <? print $search_in_both; ?>> <? print $advance_option_both; ?> <br> 
                                        <input type="radio" name="search_in" value="Question Title" <? print $search_in_title; ?>> <? print $advance_option_qt; ?> <br> 
                                        <input type="radio" name="search_in" value="Question Description" <? print $search_in_description; ?>> <? print $advance_option_qd; ?> 
                                </td>
                          </tr>
                          <tr> 
                                <td align="right">&nbsp; <? print $advance_select_category_text; ?></td>
                                <td>&nbsp;
                                        <select name="category" size="1" id="category">
                                          <option value="0">-- <? print $search_all_categories_text; ?> --</option>
                                          <?
                                                $category_id_to_select = $category_id; 
                                                // Protected Section for Only Authorized Members........ 
                                                session_start();
                                                if(($_SESSION[member_id_Session]!="")||($_SESSION[member_username_Session]!="" ))
                                                {
                                         ?>
                                                        <OPTGROUP label="----------------------------------------------------"></OPTGROUP>
                                                        <OPTGROUP label="UNPROTECTED CATEGORIES">
                                                                <? include ('include/list-categories.php') ?>
                                                        </OPTGROUP>
                                                        <OPTGROUP label="----------------------------------------------------"></OPTGROUP>
                                                        <OPTGROUP label="PROTECTED CATEGORIES">
                                                                <? include ('include/list-protected-categories.php') ?>
                                                        </OPTGROUP>
                                         <?
                                                }
                                                else
                                                {
                                                           include ('include/list-categories.php'); 
                                                }
                                        ?>
                                        </select>
                                </td>
                          </tr>
                          <tr> 
                                <td valign="top" align="right">&nbsp; <? print $advance_sort_results_text; ?></td>
                                <td>
                                        <input type="radio" name="sort_results_by" value="popularity" <? print $sort_by_popularity; ?>> <? print $advance_option_popularity; ?> <br> 
                                        <input type="radio" name="sort_results_by" value="latest" <? print $sort_by_latest; ?>> <? print $advance_option_latest_first; ?> <br> 
                                </td>
                          </tr>
                          <tr> 
                                <td>&nbsp;</td>
                                <td height="40">&nbsp;<input type="submit" name="Submit" value="<? print $home_search_button_caption; ?>"></td>
                          </tr>
                        </table>
     
            </form>
        </td>
  </tr>
 
  <tr <? print $dir; ?>> 
    <td colspan="2" height="20">
                        <? 
                        if($total_search_results  > 0)
                        {
                          // Script for Paging ...........
                                $file_name = "advance-search.php";
                                print "<p id=\"glossary\">&nbsp;&nbsp;<strong>$search_pages_text: </strong>";

                                        if($startfrom == 1 ) {$startfrom = 0; }
                                        $sort_order = ""; $mode= 0; $subcategory_id = 0; 
                                        print paging($total_search_results , $limit, $file_name, $sort_order, $startfrom, $mode, $subcategory_id, $get_usersearch_variables);

                                print "</p>";

                                // To Display the Status of Displaying Results.....
                                $to = $startfrom + $limit;
                                if($to > $total_search_results)
                                {
                                        $to = ($to - ($to - $total_search_results));
                                }
                                $message_display_results = "$advance_record_found_desc1 ".($startfrom+1)." $advance_record_found_desc2 $to $advance_record_found_desc3 $total_search_results $advance_record_found_desc4";                                      
                         }
                        ?>

        </td>
  </tr>
        <? 
                if($search_keyword != "")
                { 
        ?>
                  <tr> 
                        <td class="section-title"><img src="images/articles-theme.gif" width="25" height="28" style="vertical-align: middle;"> 
                          <? print $total_search_results; ?> <? print $search_records_found_title; ?></td>
                        <td align="right" class="section-title"><span style="font:normal;"><? print $message_display_results; ?></span>  &nbsp;&nbsp;</td>
                  </tr>
        <?  } ?>
  
  <tr> 
    <td colspan="2">&nbsp;</td>
  </tr>

 <tr <? print $dir; ?>> 
    <td colspan="2"> 
        <? print $display_results; ?> 
        </td>
 </tr>
  
  <tr <? print $dir; ?>> 
    <td colspan="2">
                <? if($total_search_results  > 0)
                { // Script for Paging ...........
                        print "<p id=\"glossary\">&nbsp;&nbsp;<strong>$search_pages_text: </strong>";
                                if($startfrom == 1 ) {$startfrom = 0; }
                                $sort_order = ""; $mode= 0; $subcategory_id = 0; 
                                print paging($total_search_results , $limit, $file_name, $sort_order, $startfrom, $mode, $subcategory_id, $get_usersearch_variables);
                        print "</p>";
                }?>

        </td>
  </tr>

<!-- page copyright.php -->
<? include('include/copyright.php');    ?>
</table>
<p align="center" style="color: #FFFFFF; font-family: Verdana; font-size: xx-small;">
Powered by <a href="http://www.knowledgebase-script.com" title="PHPKB Knowledge Base Software" target="_blank">PHPKB Knowledge Base Software</a>
</p>
</body>

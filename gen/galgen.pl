#!/usr/bin/perl

# gallery generator v2.1
# by demontagu.com


my %gals = (  "01" => "montenegro",
              "02" => "people",
              "03" => "slum area",
           );


my $gallery_name;
my @galfiles = ( );
my %galdesc = {};

sub extract_string
{
    my $file = shift;
    my $ret;

    open (INPUT, "<", $file) or return "";
    while (<INPUT>) {
        $ret .= $_;
    }
    close (INPUT);
    
    $ret =~ s/\n/ /g;
    $ret =~ s/^\s+//;
    $ret =~ s/\s+$//;
    
    return $ret;
}

sub counstructor
{
    $gallery_name = extract_string("desc/gallery.txt");
    print "Gallery: ".$gallery_name."\n";
    
    opendir(DIRHANDLE, "images") or die "couldn't open images : $!";

    while ( defined (my $filename = readdir(DIRHANDLE)) ) {
        if ($filename =~ m/\d\d.*/) {
            push (@galfiles, $filename);
            
            my $desctxt = $filename;
            $desctxt =~ s/\.jpg/\.txt/;
            $desctxt = extract_string("desc/".$desctxt);
            
            $galdesc{$filename} = $desctxt;
            
        }
    }
    closedir(DIRHANDLE);
}

sub gen_menu
{
    my $gal = shift;

    my $menu = 
'<!-- begin menu -->
    <div class="menu">
        <table>
        <tr><td></td><td>
            <a href="../../"><span class="menu_l1">home</span></a>
        </td></tr>
        <tr><td></td><td>
            <span class="menu_l1">galleries</span>
        </td></tr>
        ';
        
        
    foreach $galindex (sort keys %gals)
    {
        if ($gal eq $gals{$galindex}) {
            $menu .= '<tr><td><img title="active" alt="active" src="../../nav/nav_active.png" border="0" /></td><td>
            ';
        } else {
#            $menu .= '<tr><td><img title="active" alt="active" src="../../nav/nav_inactive.png" border="0" /></td><td>
            $menu .= '<tr><td></td><td>
            ';
        }
        $menu .= '<span class="menu_l2p">
            <a href="../../galleries/'.$galindex.'/01.html"><span class="menu_l2">'.$gals{$galindex}.'</span></a>
            </span>
        </td></tr>
        ';
    }
        
        
    $menu .= '
        <tr><td></td><td>
            <span class="menu_l2">&nbsp;</span>
        </td></tr>
        <tr><td></td><td>
            <a href="../../links.html"><span class="menu_l1">links</span></a>
        </td></tr>
        <tr><td></td><td>
            <a href="../../about.html"><span class="menu_l1">about</span></a>
        </td></tr>
        <tr><td></td><td>
            <span class="menu_l1">&nbsp;</span>
        </td></tr>
        </table>
    </div>
<!-- end menu -->
'    ;
    return $menu;
}

sub gen_thumbs
{
    my $hightlight = shift;
    my $thumbs;
    
    $thumbs .= '<!-- begin thumbs -->
<table align="left" class="thumbs">
<tr>'
;
    
    foreach my $filename (@galfiles) {
        if ($filename =~ m/(\d\d).*/) 
        {
            my $imgno = $1;
            my $desctxt = $galdesc{$filename};
            my $border = ($imgno == $hightlight) ? "1" : "0";

        
            $thumbs .= '<td width="48">
<p class="framethumbnail"><a href="'.$imgno.'.html">
<img src="thumbnails/'.$filename.'" width="44" height="44" border="'.$border.'" title="'.$desctxt.'" alt="'.$desctxt.'" /></a>
</p>
</td>'
;
        }
    }
    $thumbs .= '<td></td></tr>
</table>
<!-- end thumbs -->';
    return $thumbs;
}

sub gen_header
{
    return '<!-- begin header -->
<!-- end header -->';
}

sub gen_footer
{
#    return '<!-- begin footer -->
#<!-- end footer -->';

    return '<!-- begin footer -->
<script type="text/javascript">
var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
document.write(unescape("%3Cscript src=\'" + gaJsHost + "google-analytics.com/ga.js\' type=\'text/javascript\'%3E%3C/script%3E"));
</script>
<script type="text/javascript">
try {
var pageTracker = _gat._getTracker("UA-1839044-2");
pageTracker._trackPageview();
} catch(err) {}
</script>
<!-- end footer -->';
}

sub gentargets
{
    my $sz = @galfiles;
    
    for ($i=0; $i < $sz; $i++) {
        my $filename = $galfiles[$i];
    
        $filename =~ m/(\d\d).*/;
        my $imgno = $1;
        my $desctxt = $galdesc{$filename};
        
        my @index = ("","","","");
        $index[0] = $galfiles[0];
        if ($i == 0) {
            $index[1] = $galfiles[$sz-1];
        } else {
            $index[1] = $galfiles[$i-1];
        }
        if ($i == $sz - 1) {
            $index[2] = $galfiles[0];
        } else {
            $index[2] = $galfiles[$i+1];
        }
        $index[3] = $galfiles[$sz-1];
        
        for (@index) {
            s/(\d\d).*/$1/;
        }
        

        open (OUT_TARGET, ">$imgno.html") or die $!;
        
        my $menu = gen_menu($gallery_name);
        my $thumbs = gen_thumbs($imgno);
        
        print OUT_TARGET
'<?xml version="1.0" encoding="UTF-8"?>

<!DOCTYPE html
    PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta name="keywords" content="demontagu, photography, black and white photography, 6x6, medium format, 35 mm" />
<meta name="description" content="demontagu.com photography" />
<meta name="author" content="demontagu.com" />
<meta name="generator" content="demontagu.com/gen/galgen.html" />

<link rel="stylesheet" href="../../css/style2.css" type="text/css" />
<link rel="alternate"  href="../../rss/news.xml"  type="application/rss+xml" title="demontagu.com rss feed" />

<title>demontagu.com - '.$gallery_name.' - '.$desctxt.'</title>
</head>
<body>
  <div id="shim"></div>
  <div id="wrapper">
'.gen_header().'
  <table align="center" width="740" height="600" class="canvas">
  <tr>
  <td valign="top" width="160">
'.$menu.'
  </td>
  <td width="500">
    <table align="center">
     <tr>
      <td>
<!-- begin img -->
        <table class="image" border="0" cellspacing="0" cellpadding="0">
        <tr><td height="480" width="500">
            <div align="center">
            <a href="'.$index[2].'.html">
            <img border="0" src="images/'.$filename.'" title="next" alt="'.$desctxt.'" />
            </a>
            </div>
        </td></tr>
        <tr><td>
            <table width="500">
            <tr>
            <td align="left" valign="top">
            <span class="textdesc">'.$desctxt.'</span>
            </td>
            <td align="right" valign="middle">
            <span class="textreg">
            <a href="'.$index[1].'.html"><img src="../../nav/nav_prev.png" border="0" title="previous" alt="previous" /></a>
            <a href="'.$index[2].'.html"><img src="../../nav/nav_next.png" border="0" title="next" alt="next" /></a>
            </span>
            </td></tr>
            </table>
        </td></tr>
        </table>
<!-- end img -->
  </td>
 </tr>
 <tr>
  <td width="500">
'.$thumbs.'
  </td>
 </tr>
</table>
</td>
</tr>
</table>
</div>
'.gen_footer().'
</body>
</html>
';
        close (OUT_TARGET) or die $!;
    }
}

#-------------------------------------------------------------------------------------------------------

counstructor();
gentargets();

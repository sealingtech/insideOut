#Define the website that is hosting category test pages
$testSite="http://testrating.webfilter.bluecoat.com/"

$Define the string that determines whether the category test page was returned
$pattern="This is a Symantec WebFilter test rating page categorized as"

$Place the list of categories into an array - note that this will be used to generate the URI to the test page. If you switch test sites, this will definitely break if they use a different URL path. 
$categories = @" 
Abortion
Adult/Mature Content
Alcohol
Alternative Spirituality/Belief
Art/Culture
Auctions
Audio/Video Clips
Brokerage/Trading
Business/Economy
Charitable Organizations
Chat (IM)/SMS
Child Pornography
Computer/Information Security
Content Servers
Controlled Substances
Dynamic DNS Host
E-Card/Invitations
Education
Email
Entertainment
Extreme
File Storage/Sharing
Financial Services
For Kids
Gambling
Games
Government/Legal
Hacking
Health
Humor/Jokes
Informational
Uncategorized
Internet Connected Devices
Internet Telephony
Intimate Apparel/Swimsuit
Job Search/Careers
Malicious Outbound Data/Botnets
Malicious Sources/Malnets
Marijuana
Media Sharing
Military
Mixed Content/Potentially Adult
News/Media
Newsgroups/Forums
Non-Viewable/Infrastructure
Nudity
Office/Business Applications
Online Meetings
Peer-to-Peer (P2P)
Personal Sites
Personals/Dating
Phishing
Piracy/Copyright Concerns
Placeholders
Political/Social Advocacy
Pornography
Potentially Unwanted Software
Proxy Avoidance
Radio/Audio Streams
Real Estate
Reference
Religion
Remote Access Tools
Restaurants/Dining/Food
Scam/Questionable/Illegal
Search Engines/Portals
Sex Education
Sexual Expression
Shopping
Social Networking
Society/Daily Living
Software Downloads
Spam
Sports/Recreation
Suspicious
Technology/Internet
Tobacco
Translation
Travel
TV/Video Streams
Vehicles
Violence/Hate/Racism
Weapons
Web Ads/Analytics
Web Hosting
"@ -split "`n" | % { $_.trim() }

#Initialize counter for number of sites blocked
$i = 0

#For loop to generate the URL, perform URLencoding, perform web request, search response for defined pattern, and return error.
Foreach ($category in $categories) {
    $fullPath = $testSite + $category
    $URLencode = [uri]::EscapeUriString($fullPath)
    $html = Invoke-WebRequest -Uri $URLencode
    $nullTest = $html.RawContent | Select-String -Pattern $pattern
    if ($nullTest -eq $null)
    {
        Write-Host $category " was blocked the web proxy"
        $i++
    }
}

#Post run message
Write-Host "Category check complete:" $i "site(s) was/were blocked by the web proxy"

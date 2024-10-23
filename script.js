const Parser = require('rss-parser');
const parser = new Parser();

async function fetchRssToJson(url) {
  try {
    // Parse the RSS feed
    let feed = await parser.parseURL(url);

    // Convert the RSS feed object to JSON
    console.log(JSON.stringify(feed, null, 2));
  } catch (error) {
    console.error('Error fetching RSS feed:', error);
  }
}

// URL of the RSS feed to convert
const rssFeedUrl = 'https://sportstar.thehindu.com/archery/feeder/default.rss';

fetchRssToJson(rssFeedUrl);

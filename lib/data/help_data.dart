class HelpItem {
  String? title;
  String? description;
  bool isExpanded;
  HelpItem({
    required this.title,
    required this.description,
    this.isExpanded = false,
  });
}

List<HelpItem> helpList = [
  HelpItem(
    title: 'Prime or Not Prime?',
    description:
        'You can use this feature to check whether or not a number is prime. A prime number is a whole number greater than 1 whose only factors are 1 and itself. A factor is a whole number that can be divided evenly into another number. The result is the one with green indicator. For example, if you input a number, click on the \'=\' button, and the color of the \'Prime\' indicator turns green, it means the number is a prime number.',
  ),
  HelpItem(
    title: 'Triangle Calculator',
    description:
        'Get the area and perimeter of a triangle. Choose the type of the triangle, and then input all the required parameters in the provided text field. Click on the calculate button to get the result.',
  ),
  HelpItem(
    title: 'Travel Sites',
    description:
        'This feature provides a list of site recommendation that can help you while traveling. A detailed page is available for each recommendation, consisting of name, company, tags, rating, size, description, preview images, and links that can direct you to the site. You can also click on the favorite button to mark the sites you like. You can narrow down your search by clicking on the tags you want to explore.',
  ),
  HelpItem(
      title: 'Favorites',
      description:
          'All the sites that you favorited will be available here. You can unfavorite a site to remove it from this page.'),
  HelpItem(
    title: 'Team Members',
    description:
        'This page is dedicated to the people behind this app who have contributed their time and effort to build a seamless, innovative, and user-centric platform that aims to revolutionize the way you experience Traveloco.',
  ),
  HelpItem(
    title: 'Stopwatch',
    description:
        'You can use a stopwatch to measure elapsed time. Click on the start button at the bottom-right side of the page to start the stopwatch. Stop the stopwatch by clicking the stop button and reset it by clicking the reset button.',
  ),
];

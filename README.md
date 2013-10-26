iOS Contributors
================

Show a live view of the contributors that helped make your iOS project happen.

![alt tag](http://i.imgur.com/W2XmJur.png)

iOS Contributors provides an easy-to-implement view that shows a live list of all contributors to your iOS app (or any project, really!) hosted on GitHub.
And I do mean easy to implement.

    UIContributorsView *contributorsView = [[UIContributorsView alloc] initWithFrame:self.bounds];
    [self addSubview:self.contributorsView];
    [self.contributorsView showContributorsForRepo:@"github/Mantle"];
    
The above code will show all of the current contributors, in order, to [github's Mantle repo](https://github.com/github/Mantle).

Overall, this can be a great credits page on your app (that's what it was originally created for, after all), and you won't even have to lift a finger. Except the ones you use to type.

Example Project
---------------

The image at the start of this Readme file comes straight from the included sample project. Simply enter your repo into the textbox near the top of the screen to see your contributors. The view that you would see in your own app is just about everything under that textbox- and, of course, would always point directly to your repo.

Contributing
------------

This project was authored as part of the credits page on a different app, and at this point simply meets the needs for that particular situation. Those needs should work well for most apps, but if there's something you want changed, simply ask- or, if you can, change it yourself and submit a pull request- and it'll be added as soon as possible!

Documentation
-------------

... is sparse at the moment. The above code segment is pretty much all you need, although if you think some particular options would be useful, just ask!
Just be sure to `#import "UIContributorsView.h"` at some point.

This may also be a good spot to discuss GitHub's API limits- they should be fine for production, but as you're testing, if you hit the limit, simply set `self.authToken` inside of `UIContributorsView.m` (it's one of the first few lines) to your own [token](https://github.com/settings/applications) and you'll be good to go.

Thank You
---------

Thanks in particular to [json-framework](https://github.com/stig/json-framework/), which was indescribably useful in parsing through the data used by the API.

And of course, a huge thank you to anyone who improves this project by contributing to it- I'd list your names here, but luckily there's already a live list in the example! Funny how things work out.
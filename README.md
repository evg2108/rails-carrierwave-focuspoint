# RailsCarrierwaveFocuspoint

CarrierWave extension for specifying focus point on image before they upload on server and cropped.

This gem based on [helper tool](http://jonom.github.io/jquery-focuspoint/demos/helper/index.html) of jquery.focuspoint javascript library (https://github.com/jonom/jquery-focuspoint)

## Installation

in Gemfile

```Ruby
    gem 'rails-carrierwave-focuspoint'
```

## Usage

For using this gem you must add fields `focus_x:decimal` and `focus_y:decimal` to your db table used for storing CarrierWave picture information. Use migration:

```Ruby
    class AddFocusToUsers < ActiveRecord::Migration
      def change
        add_column :users, :focus_x, :decimal
        add_column :users, :focus_y, :decimal
      end
    end
```

in CarrierWave uploader

```Ruby
    class UserAvatarUploader < CarrierWave::Uploader::Base
      include CarrierWave::MiniMagick
      
      version :small do
        process crop_with_focuspoint: [100, 100]
      end
      
      version :big do
        process crop_with_focuspoint: [300, 200]
      end
    end
```

in model

```Ruby
    class User < ActiveRecord::Base
        mount_uploader :avatar, UserAvatarUploader
    end
```

in .js file

```js
    //= require focuspoint.js
    //= require_self
    
    $(document).ready(function() {
        document.focuspoint.init(file_input_id: 'user_avatar');
    });
```

in .css file

```css
    /*
    *= require focuspoint_control.css
    */
```

in view template

```haml
    = form_for @user do |f|
        = f.input :avatar
        = f.focuspoint_control :avatar
```

## LICENSE

This project rocks and uses MIT-LICENSE.

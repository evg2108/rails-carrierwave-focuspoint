document.focuspoint = (function() {
    var exports = { };

    var internal = {
        focusPointAttr: {
            x: 0,
            y: 0
        }
    };

    var bind_click_event = function(e){

        var imageW = $(this).width();
        var imageH = $(this).height();

        //Calculate FocusPoint coordinates
        var offsetX = e.pageX - $(this).offset().left;
        var offsetY = e.pageY - $(this).offset().top;
        var focusX = (offsetX/imageW - 0.5)*2;
        var focusY = (offsetY/imageH - 0.5)*(-2);
        internal.focusPointAttr.x = focusX;
        internal.focusPointAttr.y = focusY;
        internal.input_x.val(internal.focusPointAttr.x);
        internal.input_y.val(internal.focusPointAttr.y);

        if (exports.options.debug) {
            console.log(internal.focusPointAttr.x);
            console.log(internal.focusPointAttr.y);
        }

        //Leave a sweet target reticle at the focus point.
        var percentageX = (offsetX/imageW)*100;
        var percentageY = (offsetY/imageH)*100;
        $('.focuspoint-control-target').css({
            'top':percentageY+'%',
            'left':percentageX+'%'
        });
    }

    var readURL = function(input)
    {
        if (input.files && input.files[0]) {
            var reader = new FileReader();

            reader.onload = function(e){
                if (!internal.image_loaded) {
                    internal.image_loaded = true;
                    internal.focuspoint_control_target_overlay.on('load', function () {
                        internal.current_image_width = this.width;
                        internal.current_image_height = this.height;

                        internal.focuspoint_control_target_overlay.on('click', bind_click_event);
                    });
                }

                internal.focuspoint_control.show();
                internal.focuspoint_control_image.attr('src', e.target.result);
                internal.focuspoint_control_target_overlay.attr('src', e.target.result);
            };
            reader.readAsDataURL(input.files[0]);
        }
    };

    var init_options = function(options) {
        options = options || {};

        options.file_input_id = options.file_input_id ? '#' + options.file_input_id : '#file_input_focuspoint';
        options.file_input = $(options.file_input_id);

        if (options.file_input.length > 0) {
            internal.input_x = $('.focus_x');
            internal.input_y = $('.focus_y');

            internal.focuspoint_control_selector = '.focuspoint-control';
            internal.focuspoint_control = $(internal.focuspoint_control_selector);
            if (internal.focuspoint_control.length == 0) {
                throw "element '" + internal.focuspoint_control_selector + "' not found";
            }

            internal.focuspoint_control_image = internal.focuspoint_control.find('img.focuspoint-control-image');
            if (internal.focuspoint_control_image.length == 0) {
                throw "element '" + internal.focuspoint_control_selector + " img.focuspoint-control-image" + "' not found";
            }

            internal.focuspoint_control_target_overlay = internal.focuspoint_control.find('img.focuspoint-control-target-overlay');
            if (internal.focuspoint_control_target_overlay.length == 0) {
                throw "element '" + internal.focuspoint_control_selector + " img.focuspoint-control-target-overlay" + "' not found";
            }

            if (internal.focuspoint_control_image.attr('src')) {
                internal.image_loaded = true;
                internal.current_image_width = internal.focuspoint_control_image.width();
                internal.current_image_height = internal.focuspoint_control_image.height();

                $('.focuspoint-control-target').css({
                    'top': (((internal.input_y.val() || 0) / (-2)) + 0.5) * 100 + '%',
                    'left': (((internal.input_x.val() || 0) / 2) + 0.5) * 100 + '%'
                });
                internal.focuspoint_control_target_overlay.on('click', bind_click_event);
            }
        }
        exports.options = options;

        return options;
    };

    exports.init = function(options) {
        init_options(options);

        if (options.file_input.length > 0) {
            options.file_input.change(function(){
                if (exports.options.after_change) { exports.options.after_change(); }
                readURL(this);
            });
        }
    };

    return exports;
})();
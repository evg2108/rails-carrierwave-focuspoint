module FocuspointRails
  module UploaderAdditions
    # Performs cropping with focuspoint
    def crop_with_focuspoint(width = nil, height = nil)
      if self.respond_to? "resize_to_limit"
        begin
          x = model.focus_x || 0
          y = -(model.focus_y || 0)

          manipulate! do |img|
            orig_w = img['width']
            orig_h = img['height']

            ratio = width.to_f / height
            orig_ratio = orig_w.to_f / orig_h

            x_offset = 0
            y_offset = 0
            w = orig_w
            h = orig_h
            if ratio < orig_ratio
              w = orig_h * ratio

              half_w = w / 2.0
              half_orig_w = orig_w / 2.0

              x_offset = x * half_orig_w

              x_offset = (x <=> 0.0) * (half_orig_w - half_w) if x != 0 && x_offset.abs > half_orig_w - half_w
            elsif ratio > orig_ratio
              h = orig_w / ratio

              half_h = h / 2.0
              half_orig_h = orig_h / 2.0

              y_offset = y * half_orig_h

              y_offset = (y <=> 0.0) * (half_orig_h - half_h) if y != 0 && y_offset.abs > half_orig_h - half_h
            end

            img.combine_options do |op|
              op.crop "#{w.to_i}x#{h.to_i}#{'%+d' % x_offset.round}#{'%+d' % y_offset.round}"
              op.gravity 'Center'
            end
            img.resize("#{width}x#{height}")
            img
          end

        rescue Exception => e
          raise "Failed to crop - #{e.message}"
        end

      else
        raise "Failed to crop #{attachment}. Add mini_magick."
      end
    end
  end ## End of UploaderAdditions
end ## End of FocuspointRails

if defined? CarrierWave::Uploader::Base
  CarrierWave::Uploader::Base.class_eval do
    include FocuspointRails::UploaderAdditions
  end
end
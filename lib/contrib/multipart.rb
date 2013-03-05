require 'net/http'
require 'digest/sha1'
require "erb"
include ERB::Util

class Net::HTTP::Post
  def set_multipart_form_data(params, boundary=nil)
    boundary ||= Digest::SHA1.hexdigest(params.inspect)
    chunks = params.map { |k,v|
      if(v.is_a?(File))
        %Q{Content-Disposition: form-data; name="#{k}"; filename="#{File.basename(v.path)}"\r\n} +
        %Q{Content-Transfer-Encoding: binary\r\nContent-Type: application/octet-stream\r\n\r\n} +
        %Q{#{v.read}\r\n}
      else 
        %Q{Content-Disposition: form-data; name="#{url_encode(k)}"\r\n} +
        %Q{\r\n#{v}\r\n} 
      end
    }
    self.body = "--#{boundary}\r\n" + chunks.join("--#{boundary}\r\n") + "--#{boundary}--\r\n"
    # puts self.body
    self.content_type = "multipart/form-data; boundary=#{boundary}"
  end
end
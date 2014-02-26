class BikeBookIntegration
  require 'net/http'
  
  def make_request(query, method = nil)
    uri = URI("http://bikebook.io#{method}")
    uri.query = URI.encode_www_form(query)
    res = Net::HTTP.get_response(uri)
    return nil unless res.is_a?(Net::HTTPSuccess)

    response = JSON.parse(res.body)
    return response if response.kind_of?(Array)
    response.with_indifferent_access     
  end

  def get_model(options = {})
    return nil unless options[:year].present? && options[:manufacturer].present? && options[:frame_model].present?
    # We're book sluging everything because, url safe (It's the same method bikebook uses)
    query = { manufacturer: Slugifyer.book_slug(options[:manufacturer]),
      year: options[:year],
      frame_model: Slugifyer.book_slug(options[:frame_model])
    }

    make_request(query)
  end

  def get_model_list(options = {})
    return nil unless options[:manufacturer].present?
    query = { manufacturer: Slugifyer.book_slug(options[:manufacturer]) }
    query[:year] = options[:year] if options[:year].present?
    
    make_request(query, "/model_list/")
  end

end
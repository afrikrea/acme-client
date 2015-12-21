class Acme::Client::Resources::Challenges::TLSSNI01 < Acme::Client::Resources::Challenges::Base
  def hostname
    digest = crypto.digest.hexdigest(authorization_key)
    "#{digest[0..31]}.#{digest[32..64]}.acme.invalid"
  end

  def certificate
    self_sign_certificate.certificate
  end

  def private_key
    self_sign_certificate.private_key
  end

  def request_verification
    response = client.connection.post(@uri, { resource: 'challenge', type: 'tls-sni-01', keyAuthorization: authorization_key })
    response.success?
  end

  private

  def self_sign_certificate
    @self_sign_certificate ||= Acme::Client::SelfSignCertificate.new(subject_alt_names: [hostname])
  end
end

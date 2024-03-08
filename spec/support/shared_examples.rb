shared_examples 'ok' do
  it 'returns ok' do
    expect(response).to have_http_status(:ok)
  end

  it 'returns 200 response schema' do
    assert_response_schema_confirm(200)
  end
end

shared_examples 'bad request' do
  it 'returns bad request' do
    expect(response).to have_http_status(:bad_request)
  end

  it 'returns 400 response schema' do
    assert_response_schema_confirm(400)
  end
end

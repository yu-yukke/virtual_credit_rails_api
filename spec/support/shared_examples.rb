shared_examples 'ok' do
  it 'returns ok' do
    expect(response).to have_http_status(:ok)
  end

  it 'returns 200 response schema' do
    assert_response_schema_confirm(200)
  end
end

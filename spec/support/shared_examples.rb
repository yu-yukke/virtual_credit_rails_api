shared_examples 'ok' do
  it 'returns ok' do
    expect(response).to have_http_status(:ok)
  end

  it 'returns 200 response schema' do
    assert_response_schema_confirm(200)
  end
end

shared_examples 'created' do
  it 'returns created' do
    expect(response).to have_http_status(:created)
  end

  it 'returns 201 response schema' do
    assert_response_schema_confirm(201)
  end
end

shared_examples 'no_content' do
  it 'returns no content' do
    expect(response).to have_http_status(:no_content)
  end

  it 'returns 204 response schema' do
    assert_response_schema_confirm(204)
  end
end

shared_examples 'bad_request' do
  it 'returns bad request' do
    expect(response).to have_http_status(:bad_request)
  end

  it 'returns 400 response schema' do
    assert_response_schema_confirm(400)
  end
end

shared_examples 'not_found' do
  it 'returns not found' do
    expect(response).to have_http_status(:not_found)
  end

  it 'returns 404 response schema' do
    assert_response_schema_confirm(404)
  end
end

shared_examples 'conflict' do
  it 'returns conflict' do
    expect(response).to have_http_status(:conflict)
  end

  it 'returns 409 response schema' do
    assert_response_schema_confirm(409)
  end
end

shared_examples 'unprocessable_entity' do
  it 'returns unprocessable entity' do
    expect(response).to have_http_status(:unprocessable_entity)
  end

  it 'returns 422 response schema' do
    assert_response_schema_confirm(422)
  end
end

shared_examples 'unauthorized' do
  it 'returns unauthorized' do
    expect(response).to have_http_status(:unauthorized)
  end

  it 'returns 401 response schema' do
    assert_response_schema_confirm(401)
  end
end

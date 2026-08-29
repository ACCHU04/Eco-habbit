# EcoHabit — Testing Strategy

**Document Reference**: PRD v1.0, Section 12
**Last Updated**: July 2026
**Status**: Draft

---

## Overview

This document defines the testing strategy for EcoHabit across all layers: frontend, backend, AI service, database, and integration.

### Testing Principles

- Test early, test often
- Automate repetitive tests
- Test user journeys, not just code
- Maintain test coverage > 80%
- Test security at every layer

---

## Testing Pyramid

```
           ┌─────────────┐
           │   E2E Tests │  (Few)
           │  (10%)      │
           └──────┬──────┘
                  │
         ┌────────┴────────┐
         │ Integration Tests│  (Some)
         │    (30%)         │
         └────────┬─────────┘
                  │
      ┌───────────┴───────────┐
      │      Unit Tests       │  (Many)
      │       (60%)           │
      └───────────────────────┘
```

### Coverage Targets

| Layer | Unit | Integration | E2E | Total |
|---|---|---|---|---|
| Flutter | 70% | 20% | 10% | 80% |
| NestJS | 70% | 20% | 10% | 80% |
| AI Service | 70% | 20% | 10% | 80% |
| Database | — | 100% | — | 100% |

---

## Frontend Testing (Flutter)

### Unit Tests

**Framework**: `flutter_test`

**What to test**:
- Data models (serialization/deserialization)
- Utility functions
- Validators
- State management logic

**Example**:
```dart
test('MarketplaceListing model should serialize correctly', () {
  final listing = MarketplaceListing(
    id: 'test-id',
    title: 'Test Listing',
    price: 250,
    category: 'textbooks_stationery',
  );
  
  expect(listing.title, 'Test Listing');
  expect(listing.price, 250);
});
```

### Widget Tests

**Framework**: `flutter_test`

**What to test**:
- Widget rendering
- User interactions
- State changes
- Navigation

**Example**:
```dart
testWidgets('Login screen should show email and password fields', (tester) async {
  await tester.pumpWidget(MaterialApp(home: LoginScreen()));
  
  expect(find.byType(TextField), findsNWidgets(2));
  expect(find.text('Email'), findsOneWidget);
  expect(find.text('Password'), findsOneWidget);
});
```

### Integration Tests

**Framework**: `integration_test`

**What to test**:
- Complete user journeys
- Navigation flows
- API integration
- Form submissions

**Example**:
```dart
testWidgets('Complete registration flow', (tester) async {
  await tester.pumpWidget(EcoHabitApp());
  
  // Tap register button
  await tester.tap(find.text('Register'));
  await tester.pumpAndSettle();
  
  // Fill registration form
  await tester.enterText(find.byKey(Key('email')), 'test@college.edu');
  await tester.enterText(find.byKey(Key('password')), 'password123');
  
  // Submit form
  await tester.tap(find.text('Create Account'));
  await tester.pumpAndSettle();
  
  // Verify navigation to home
  expect(find.text('Welcome'), findsOneWidget);
});
```

---

## Backend Testing (NestJS)

### Unit Tests

**Framework**: Jest

**What to test**:
- Service methods
- Utility functions
- Validators
- Business logic

**Example**:
```typescript
describe('MarketplaceService', () => {
  it('should create a listing', async () => {
    const dto = {
      title: 'Test Listing',
      price: 250,
      category: 'textbooks_stationery',
    };
    
    const result = await service.createListing(dto);
    
    expect(result.title).toBe('Test Listing');
    expect(result.price).toBe(250);
  });
});
```

### Integration Tests

**Framework**: Jest + Supertest

**What to test**:
- API endpoints
- Database operations
- Authentication
- Error handling

**Example**:
```typescript
describe('MarketplaceController', () => {
  it('should return listings', async () => {
    const response = await request(app.getHttpServer())
      .get('/marketplace/listings')
      .set('Authorization', `Bearer ${token}`)
      .expect(200);
    
    expect(response.body.data).toBeInstanceOf(Array);
  });
});
```

### E2E Tests

**Framework**: Jest + Supertest

**What to test**:
- Complete API workflows
- Multi-step operations
- Cross-module interactions

**Example**:
```typescript
describe('Marketplace Flow', () => {
  it('should create, read, update, delete listing', async () => {
    // Create
    const created = await request(app.getHttpServer())
      .post('/marketplace/listings')
      .send({ title: 'Test', price: 100 })
      .expect(201);
    
    // Read
    await request(app.getHttpServer())
      .get(`/marketplace/listings/${created.body.data.id}`)
      .expect(200);
    
    // Update
    await request(app.getHttpServer())
      .put(`/marketplace/listings/${created.body.data.id}`)
      .send({ price: 150 })
      .expect(200);
    
    // Delete
    await request(app.getHttpServer())
      .delete(`/marketplace/listings/${created.body.data.id}`)
      .expect(204);
  });
});
```

---

## AI Service Testing (FastAPI)

### Unit Tests

**Framework**: pytest

**What to test**:
- Image preprocessing
- Classification logic
- DIY suggestion logic
- Cache operations

**Example**:
```python
def test_preprocess_image():
    image = Image.open('test_image.jpg')
    result = preprocess_image(image)
    
    assert result.shape == (1, 224, 224, 3)
    assert result.max() <= 1.0
    assert result.min() >= 0.0
```

### Model Accuracy Tests

**Framework**: pytest

**What to test**:
- Classification accuracy on test dataset
- Confidence thresholds
- Edge cases

**Example**:
```python
def test_classification_accuracy():
    test_images = load_test_dataset()
    correct = 0
    
    for image, expected_label in test_images:
        result = classifier.classify(image)
        if result['classification'] == expected_label:
            correct += 1
    
    accuracy = correct / len(test_images)
    assert accuracy >= 0.80, f"Accuracy {accuracy} below threshold"
```

### Performance Tests

**Framework**: pytest + locust

**What to test**:
- Response time
- Throughput
- Concurrent requests

**Example**:
```python
def test_response_time():
    image = load_test_image()
    
    start = time.time()
    result = classifier.classify(image)
    end = time.time()
    
    response_time = end - start
    assert response_time < 5.0, f"Response time {response_time}s too slow"
```

---

## Database Testing

### Migration Tests

**Framework**: Jest/Supertest + SQL

**What to test**:
- Migrations run successfully
- Rollbacks work
- Data integrity

**Example**:
```sql
-- Test enum creation
CREATE TYPE test_enum AS ENUM ('a', 'b', 'c');
SELECT 'a'::test_enum; -- Should succeed
SELECT 'd'::test_enum; -- Should fail
```

### Query Tests

**Framework**: Jest/Supertest

**What to test**:
- Query performance
- Index usage
- RLS policies

**Example**:
```typescript
it('should enforce RLS on marketplace_listings', async () => {
  // User A creates listing
  const listing = await createListing(userA, { title: 'Test' });
  
  // User B cannot delete User A's listing
  await request(app.getHttpServer())
    .delete(`/marketplace/listings/${listing.id}`)
    .set('Authorization', `Bearer ${userBToken}`)
    .expect(403);
});
```

---

## Security Testing

### Authentication Tests

| Test | Expected Result |
|---|---|
| Access without token | 401 Unauthorized |
| Access with invalid token | 401 Unauthorized |
| Access with expired token | 401 Unauthorized |
| Access with valid token | 200 OK |

### Authorization Tests

| Test | Expected Result |
|---|---|
| Student create listing | 201 Created |
| Student delete other's listing | 403 Forbidden |
| Admin delete any listing | 200 OK |
| Student access admin endpoints | 403 Forbidden |

### Input Validation Tests

| Test | Expected Result |
|---|---|
| Empty required field | 400 Bad Request |
| Invalid email format | 400 Bad Request |
| Price < 0 | 400 Bad Request |
| SQL injection attempt | 400 Bad Request |
| XSS attempt | 400 Bad Request |

---

## Performance Testing

### Load Testing

**Tool**: Locust / k6

**Targets**:
| Metric | Target |
|---|---|
| Concurrent users | 100 |
| Requests per second | 50 |
| Response time (p95) | < 500ms |
| Error rate | < 1% |

### Stress Testing

**Targets**:
| Metric | Target |
|---|---|
| Max concurrent users | 500 |
| Breaking point | Identify |
| Recovery time | < 5 minutes |

---

## Test Data Management

### Test Datasets

| Dataset | Purpose | Location |
|---|---|---|
| Test images | AI classification testing | `ai_service/tests/data/` |
| Test users | API testing | Seed script |
| Test listings | Marketplace testing | Seed script |

### Seed Script

```typescript
// scripts/seed-test-data.ts
async function seedTestData() {
  // Create test users
  await createUser({ email: 'test1@college.edu', role: 'student' });
  await createUser({ email: 'test2@college.edu', role: 'student' });
  await createUser({ email: 'admin@college.edu', role: 'admin' });
  
  // Create test listings
  await createListing({ title: 'Test Book', price: 100 });
  await createListing({ title: 'Test Laptop', price: 5000 });
}
```

---

## CI/CD Integration

### GitHub Actions Workflow

```yaml
name: Tests
on: [push, pull_request]

jobs:
  test-flutter:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter test
      - run: flutter analyze

  test-backend:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
      - run: npm ci
      - run: npm run test:cov
      - run: npm run lint

  test-ai:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
      - run: pip install -r requirements.txt
      - run: pytest --cov=app tests/
```

---

## Test Reporting

### Coverage Reports

| Tool | Output | Location |
|---|---|---|
| Flutter | HTML coverage | `coverage/html/` |
| Jest | LCOV | `coverage/lcov.info` |
| pytest | HTML | `htmlcov/index.html` |

### Quality Gates

| Gate | Threshold | Action on Fail |
|---|---|---|
| Unit test coverage | >= 80% | Block merge |
| Integration test pass | 100% | Block merge |
| Linting errors | 0 | Block merge |
| Security scan | 0 critical | Block merge |

---

## Document Reference

This document references:
- PRD v1.0, Section 12 (Acceptance Criteria)
- 10_System_Architecture.md
- 12_Development_Setup.md

This document is referenced by:
- 14_Deployment_Guide.md

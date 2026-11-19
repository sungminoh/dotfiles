---
paths:
  - "**/*.py"
  - "**/pyproject.toml"
---

# Python Testing

Tools: pytest for unit tests, pytest with httpx for integration tests, pytest-playwright for E2E.

## pytest practices

```python
import pytest
from unittest.mock import AsyncMock, Mock, patch

@pytest.fixture
def user_service(mock_db: Mock) -> UserService:
    return UserService(db=mock_db)

@pytest.mark.parametrize(("value", "expected"), [
    ("valid@email.com", True),
    ("invalid", False),
])
def test_validate_email(value: str, expected: bool) -> None:
    assert validate_email(value) == expected

@pytest.mark.asyncio
async def test_get_user(user_service: UserService) -> None:
    assert await user_service.get_user("123") is not None

@pytest.mark.asyncio
@patch("module.external_api", new_callable=AsyncMock)
async def test_with_mock(mock_api: AsyncMock) -> None:
    mock_api.return_value = {"status": "ok"}
    await function_using_api()
    mock_api.assert_awaited_once()
```

## Commands

```bash
pytest --cov=src --cov-report=term-missing   # all tests with coverage
pytest --cov=src --cov-fail-under=80         # enforce the 80% floor
pytest tests/test_user_service.py -v         # one file
pytest -k "test_create" -v                   # by name pattern
pytest -n auto                               # parallel (pytest-xdist)
```

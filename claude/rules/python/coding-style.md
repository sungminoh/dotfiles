---
paths:
  - "**/*.py"
  - "**/pyproject.toml"
---

# Python Coding Style

## Immutability (critical)

Always create new objects. Never mutate.

```python
from dataclasses import dataclass, replace

# Wrong: mutation
def update_user(user: dict, name: str) -> dict:
    user["name"] = name
    return user

# Right: new object
def update_user(user: dict, name: str) -> dict:
    return {**user, "name": name}

# Right: frozen dataclass
@dataclass(frozen=True)
class User:
    name: str
    email: str

def rename(user: User, name: str) -> User:
    return replace(user, name=name)
```

## File organization

Many small files over a few large ones:
- High cohesion, low coupling.
- 200 to 400 lines typical, 800 maximum.
- Extract utilities into separate modules.
- Organize by feature or domain, not by type.
- Expose the public API through `__init__.py`.

## Error handling

Handle errors explicitly, with specific exceptions:

```python
import logging

logger = logging.getLogger(__name__)

try:
    result = risky_operation()
except SpecificError as e:
    logger.error("Operation failed: %s", e)
    raise UserFriendlyError("Detailed user-friendly message") from e
except Exception:
    logger.exception("Unexpected error in operation")
    raise
```

## Input validation

Validate all user input with Pydantic:

```python
from pydantic import BaseModel, EmailStr, Field

class UserInput(BaseModel):
    email: EmailStr
    age: int = Field(ge=0, le=150)

validated = UserInput(email=input_email, age=input_age)  # raises ValidationError
```

## Type hints (mandatory)

Annotate every function. Use built-in generics and `X | None`:

```python
from collections.abc import Sequence

def process_items(items: Sequence[str], limit: int | None = None) -> list[str]:
    """Return at most `limit` items."""
    return list(items[:limit])
```

## Tooling

```bash
ruff check --fix .
ruff format .
mypy src/
```

## Checklist before marking work complete

- [ ] Readable, well-named code (snake_case)
- [ ] Functions under 50 lines
- [ ] Files under 800 lines
- [ ] Nesting no deeper than 4 levels
- [ ] Specific exceptions, handled explicitly
- [ ] No `print()`; use `logging`
- [ ] No hardcoded values; use constants or config
- [ ] No mutation
- [ ] Type hints on all functions
- [ ] Docstrings on public functions and classes

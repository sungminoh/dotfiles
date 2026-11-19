---
paths:
  - "**/*.py"
  - "**/pyproject.toml"
---

# Python Security

## Secrets

Read secrets from the environment (pydantic-settings if the project uses it):

```python
# Never
api_key = "sk-proj-xxxxx"

# Always
from pydantic_settings import BaseSettings, SettingsConfigDict

class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env", env_file_encoding="utf-8")

    openai_api_key: str
    database_url: str
    secret_key: str

settings = Settings()  # raises ValidationError if a value is missing
```

## SQL injection

```python
# Never: string formatting
query = f"SELECT * FROM users WHERE id = {user_id}"

# Always: parameterized queries
result = await db.execute(text("SELECT * FROM users WHERE id = :id"), {"id": user_id})

# Or the ORM (SQLAlchemy)
user = await session.get(User, user_id)
```

## Input validation (Pydantic v2)

```python
from typing import Annotated
from pydantic import BaseModel, EmailStr, Field, field_validator

class CreateUserRequest(BaseModel):
    username: Annotated[str, Field(min_length=3, max_length=50, pattern=r"^[a-zA-Z0-9_]+$")]
    email: EmailStr
    age: Annotated[int, Field(ge=0, le=150)]

    @field_validator("username")
    @classmethod
    def username_not_reserved(cls, v: str) -> str:
        if v.lower() in {"admin", "root", "system"}:
            raise ValueError("Reserved username")
        return v
```

## Dependencies

```bash
pip-audit        # scan for known vulnerabilities
uv lock          # or: poetry lock / pip freeze > requirements.txt
```

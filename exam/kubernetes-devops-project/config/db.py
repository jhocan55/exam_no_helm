import os
from sqlalchemy import create_engine, MetaData

# Read the DATABASE_URL from the environment variable
DATABASE_URL = os.getenv("DATABASE_URL", "postgresql://admin:password@localhost:5432/storedb")

engine = create_engine(DATABASE_URL)

meta = MetaData()

conn = engine.connect()
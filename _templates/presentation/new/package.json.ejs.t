---
to: <%= name %>/src/package.json
unless_exists: true
---
{
  "name": "<%= name %>",
  "private": true,
  "scripts": {
    "build": "slidev build",
    "dev": "slidev --open",
    "export": "slidev export"
  },
  "dependencies": {}
}
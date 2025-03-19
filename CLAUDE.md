# CLAUDE.md - Guide for Presentation Slides Repository

## Commands

### Project Management
- Create new presentation: `just new name`
- Run presentation: `just present project-dir` (e.g., `just present nix-intro`)
- Run demo: `just demo project-dir` (e.g., `just demo arch-install`)

### Individual Project Commands
- Run presentation in dev mode: `cd project-dir/src && npm run dev`
- Build presentation: `cd project-dir/src && npm run build`
- Export to PDF: `cd project-dir/src && npm run export`

## Code Style Guidelines
- **Slides Format**: Write slides in Markdown (slides.md)
- **Project Structure**: Each presentation has its own directory with src/ folder and justfile
- **Demos**: Place demo scripts in demo/ directory with descriptive names
- **CSS**: Custom styling in src/style.css when needed
- **Content**: Favor code examples and visualizations over text-heavy slides
- **Naming**: Use kebab-case for directories and files
- **Justfiles**: Include standard commands (present, build, demo) in each project justfile
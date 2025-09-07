const fs = require('fs');
const path = require('path');

// Function to recursively find all TypeScript files
function findTsFiles(dir, fileList = []) {
  const files = fs.readdirSync(dir);
  
  files.forEach(file => {
    const filePath = path.join(dir, file);
    const stat = fs.statSync(filePath);
    
    if (stat.isDirectory() && !file.startsWith('.') && file !== 'node_modules') {
      findTsFiles(filePath, fileList);
    } else if (file.endsWith('.ts') || file.endsWith('.tsx')) {
      fileList.push(filePath);
    }
  });
  
  return fileList;
}

// Function to restore PostHog imports
function restorePostHogImports(filePath) {
  try {
    let content = fs.readFileSync(filePath, 'utf8');
    let modified = false;
    
    // Replace mock imports with real PostHog imports
    const patterns = [
      {
        from: /\/\/ PostHog temporarily disabled - using mock\nimport posthog from ['"]@\/lib\/posthog-mock['"];?/g,
        to: "import posthog from 'posthog-js';"
      }
    ];
    
    patterns.forEach(pattern => {
      if (pattern.from.test(content)) {
        content = content.replace(pattern.from, pattern.to);
        modified = true;
      }
    });
    
    if (modified) {
      fs.writeFileSync(filePath, content, 'utf8');
      console.log(`Restored: ${filePath}`);
      return true;
    }
    
    return false;
  } catch (error) {
    console.error(`Error processing ${filePath}:`, error.message);
    return false;
  }
}

// Main execution
function main() {
  const srcDir = path.join(__dirname, '..', 'src');
  
  if (!fs.existsSync(srcDir)) {
    console.error('src directory not found');
    return;
  }
  
  console.log('Finding TypeScript files...');
  const tsFiles = findTsFiles(srcDir);
  console.log(`Found ${tsFiles.length} TypeScript files`);
  
  let updatedCount = 0;
  
  tsFiles.forEach(filePath => {
    if (restorePostHogImports(filePath)) {
      updatedCount++;
    }
  });
  
  console.log(`\nRestored ${updatedCount} files with PostHog imports`);
  console.log('PostHog has been re-enabled across the codebase');
  console.log('\nNote: You also need to restore src/instrumentation-client.ts manually');
}

main();

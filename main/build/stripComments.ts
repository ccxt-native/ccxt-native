import { readFileSync, writeFileSync, readdirSync, statSync } from 'fs';
import { join } from 'path';
import { ccxtGoDir } from './filepaths';

interface CommentStripperOptions {
    removeEmptyLines?: boolean;
    preserveBuildComments?: boolean;
}

class GoCommentStripper {
    private options: CommentStripperOptions;

    constructor(options: CommentStripperOptions = {}) {
        this.options = {
            removeEmptyLines: true,
            preserveBuildComments: false,
            ...options
        };
    }

    /**
     * Strips comments from Go source code while preserving string literals
     */
    stripComments(content: string): string {
        let result = '';
        let i = 0;
        let inString = false;
        let inChar = false;
        let escapeNext = false;
        
        while (i < content.length) {
            const char = content[i];
            
            if (escapeNext) {
                escapeNext = false;
                result += char;
                i++;
                continue;
            }
            
            if (char === '\\') {
                escapeNext = true;
                result += char;
                i++;
                continue;
            }
            
            if (char === '"' && !inChar) {
                inString = !inString;
                result += char;
                i++;
                continue;
            }
            
            if (char === '\'' && !inString) {
                inChar = !inChar;
                result += char;
                i++;
                continue;
            }
            
            // Only process comment markers when not inside strings
            if (!inString && !inChar) {
                // Check for single-line comment (//)
                if (char === '/' && i + 1 < content.length && content[i + 1] === '/') {
                    // Determine end of line first
                    const lineEnd = content.indexOf('\n', i);
                    const endIdx = lineEnd === -1 ? content.length : lineEnd;
                    const commentText = content.slice(i, endIdx);
                    const trimmedComment = commentText.trim();

                    // Preserve injection markers
                    if (
                        trimmedComment === '// BEGIN: INJECT GETTERS AND SETTERS HERE //' ||
                        trimmedComment === '// END: INJECT GETTERS AND SETTERS HERE //'
                    ) {
                        // Keep the comment as-is
                        result += commentText;
                        if (lineEnd !== -1) {
                            result += '\n';
                        }
                        i = endIdx + (lineEnd === -1 ? 0 : 1);
                        continue;
                    }

                    // Skip to end of line for other comments
                    while (i < content.length && content[i] !== '\n') {
                        i++;
                    }
                    if (i < content.length) {
                        result += '\n';
                    }
                    continue;
                }
                
                // Check for block comment (/*)
                if (char === '/' && i + 1 < content.length && content[i + 1] === '*') {
                    // Skip to end of block comment (*/)
                    i += 2;
                    while (i < content.length - 1) {
                        if (content[i] === '*' && content[i + 1] === '/') {
                            i += 2;
                            break;
                        }
                        i++;
                    }
                    continue;
                }
            }
            
            result += char;
            i++;
        }
        
        // Split into lines and filter empty lines if configured
        if (this.options.removeEmptyLines) {
            const lines = result.split('\n');
            const filteredLines = lines.filter(line => line.trim() !== '');
            return filteredLines.join('\n');
        }
        
        return result;
    }



    /**
     * Processes a single Go file
     */
    processFile(filePath: string): void {
        try {
            const content = readFileSync(filePath, 'utf8');
            const stripped = this.stripComments(content);
            writeFileSync(filePath, stripped, 'utf8');
        } catch (error) {
            console.error(`Error processing ${filePath}:`, error);
        }
    }

    /**
     * Recursively processes all Go files in a directory
     */
    processDirectory(dirPath: string): void {
        try {
            const items = readdirSync(dirPath);
            
            for (const item of items) {
                const fullPath = join(dirPath, item);
                const stat = statSync(fullPath);
                
                if (stat.isDirectory()) {
                    // Recursively process subdirectories
                    this.processDirectory(fullPath);
                } else if (item.endsWith('.go')) {
                    // Process Go files
                    this.processFile(fullPath);
                }
            }
        } catch (error) {
            console.error(`Error processing directory ${dirPath}:`, error);
        }
    }
}

export default function stripComments() {
    const stripper = new GoCommentStripper();
    stripper.processDirectory(ccxtGoDir);
}

export function stripGoCommentsInDirectory(dirPath: string, options?: CommentStripperOptions): void {
    new GoCommentStripper(options).processDirectory(dirPath);
}

// Main execution
function main() {
    const args = process.argv.slice(2);
    
    let targetDir;
    if (args.length === 0) {
        targetDir = ccxtGoDir;
    } else {
        targetDir = args[0];
    }
    
    const options: CommentStripperOptions = {};
    
    // Parse options
    for (let i = 1; i < args.length; i++) {
        switch (args[i]) {
            case '--preserve-empty-lines':
                options.removeEmptyLines = false;
                break;
            case '--preserve-build-comments':
                options.preserveBuildComments = true;
                break;
        }
    }
    
    const stripper = new GoCommentStripper(options);
    
    console.log(`Starting comment stripping in: ${targetDir}`);
    console.log(`Options:`, options);
    
    stripper.processDirectory(targetDir);
    
    console.log('Comment stripping completed!');
}

// Run if this file is executed directly
if (require.main === module) {
    main();
}

export { GoCommentStripper, CommentStripperOptions }; 
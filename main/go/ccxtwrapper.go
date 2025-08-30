package ccxt

import (
	"C"
	"encoding/json"
	"fmt"
	"math"
	"regexp"
	"strings"
	"sync"
	[imports]
)
type CCXTGoExchange struct {
	exchange ccxt.ICoreExchange
}

func NewExchange(exchangeName string, configJson string) *CCXTGoExchange {
	[wsMap]
	// First, remove the outer quotes if they exist
	configJson = strings.Trim(configJson, "\"")

	// Convert JavaScript object syntax to valid JSON:
	// 1. Replace single quotes with double quotes
	configJson = strings.ReplaceAll(configJson, "'", "\"")
	// 2. Add double quotes to unquoted keys
	configJson = regexp.MustCompile(`(\w+):`).ReplaceAllString(configJson, "\"$1\":")

	var config map[string]interface{}
	if err := json.Unmarshal([]byte(configJson), &config); err != nil {
		fmt.Printf("Go: Failed to parse configJson: %v\nInput was: %s\nProcessed to: %s\n", err, configJson, configJson)
		return nil
	}
	[instantiation]
	if !ok {
		return nil
	}

	return &CCXTGoExchange{exchange: inst}
}

func parseJSON(input string) []byte {
	var intermediate string
	if err := json.Unmarshal([]byte(input), &intermediate); err == nil {
		// Input was a double-quoted JSON string — unwrap it
		input = intermediate
	}

	var anything interface{}
	if err := json.Unmarshal([]byte(input), &anything); err != nil {
		// Return a consistent error message as JSON
		errorObj := map[string]string{"error": "Invalid JSON"}
		b, _ := json.Marshal(errorObj)
		return b
	}

	b, _ := json.Marshal(anything)
	return b
}

func sanitise(v interface{}) interface{} {
	switch x := v.(type) {
	case float64:
		if math.IsNaN(x) || math.IsInf(x, 0) {
			return nil
		}
		return x
	case map[string]interface{}:
		out := make(map[string]interface{}, len(x))
		for k, vv := range x {
			out[k] = sanitise(vv)
		}
		return out
	case []interface{}:
		out := make([]interface{}, len(x))
		for i, vv := range x {
			out[i] = sanitise(vv)
		}
		return out
	default:
		return v
	}
}

// ------------------------------------------------------------------------

// ########################################################################
// ########################################################################
// ########################################################################
// ########################################################################
// ########                        ########                        ########
// ########                        ########                        ########
// ########                        ########                        ########
// ########                        ########                        ########
// ########        ########################        ########################
// ########        ########################        ########################
// ########        ########################        ########################
// ########        ########################        ########################
// ########                        ########                        ########
// ########                        ########                        ########
// ########                        ########                        ########
// ########                        ########                        ########
// ########################################################################
// ########################################################################
// ########################################################################
// ########################################################################
// ########        ########        ########                        ########
// ########        ########        ########                        ########
// ########        ########        ########                        ########
// ########        ########        ########                        ########
// ################        ########################        ################
// ################        ########################        ################
// ################        ########################        ################
// ################        ########################        ################
// ########        ########        ################        ################
// ########        ########        ################        ################
// ########        ########        ################        ################
// ########        ########        ################        ################
// ########################################################################
// ########################################################################
// ########################################################################
// ########################################################################

// ------------------------------------------------------------------------
// METHODS BELOW THIS LINE ARE TRANSPILED

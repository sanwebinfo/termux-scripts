# custom user@localhost on terminal
prompt_context() {
  # Custom (Random emoji)
  emojis=("🦄" "😀" "🐱" "🦊" "🦝" "🦁" "🍵" "💰")
  RAND_EMOJI_N=$(( $RANDOM % ${#emojis[@]} + 1))
  prompt_segment black default "${emojis[$RAND_EMOJI_N]} "
}

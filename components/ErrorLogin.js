import Dialog, { SlideAnimation, DialogContent } from 'react-native-popup-dialog';
import { Button } from 'react-native'

<View style={styles.container}>
  <Button
    title="Login failed"
    onPress={() => {
      this.setState({ visible: true });
    }}
  />
  <Dialog
    visible={this.state.visible}
    onTouchOutside={() => {
      this.setState({ visible: false });
    }}
  >
    <DialogContent>
      <Text>Username or password was wrong please check again</Text>
    </DialogContent>
  </Dialog>
</View>
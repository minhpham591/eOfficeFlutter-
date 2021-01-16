import React, { Component } from 'react'
import { StyleSheet, Text, View, Image, TouchableWithoutFeedback, StatusBar, TextInput, SafeAreaView, Keyboard, TouchableOpacity, KeyboardAvoidingView, TouchableOpacityBase, CheckBox, Button } from 'react-native'
export default class Login extends Component {
    render() {
        return (
            <SafeAreaView style={styles.container}>
                <StatusBar barStyle="light-content" />
                <KeyboardAvoidingView behavior='padding' style={styles.container}>
                    <TouchableWithoutFeedback style={styles.container} onPress={Keyboard.dismiss}>
                        <View style={styles.container}>
                            <View style={styles.logoContainer}>
                                <Image style={styles.logo}
                                    source={require('../images/eOffice.png')}>
                                </Image>

                            </View>
                            <View style={styles.infoContainer}>
                                <Text style={styles.title}>Please enter your new password.</Text>
                                <TextInput style={styles.input}
                                    placeholder="Enter New Password"
                                    placeholderTextColor="gray"
                                    returnKeyType='next'
                                    secureTextEntry
                                    autoCorrect={false}
                                    onSubmitEditing={() => this.refs.txtPassword.focus()}
                                />
                                <TextInput style={styles.input}
                                    placeholder="Enter New Password Confirm"
                                    placeholderTextColor="gray"
                                    returnKeyType='go'
                                    secureTextEntry
                                    autoCorrect={false}
                                    ref={"txtPassword"}
                                />

                                <TouchableOpacity style={styles.buttonContainer}>
                                    <Text style={styles.buttonText}>Go</Text>
                                </TouchableOpacity>
                               
                            </View>
                        </View>
                    </TouchableWithoutFeedback>
                </KeyboardAvoidingView>
            </SafeAreaView>)
    }
}
const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: 'rgb(90,120,255)',
        flexDirection: 'column',
    },
    logoContainer: {
        alignItems: 'center',
        justifyContent: 'center',
        flex: 0.5,
        top: 75,
        bottom: 200,
    },
    logo: {
        width: 250,
        height: 180,
    },
    title: {
        color: 'black',
        fontWeight: 'bold',
        fontSize: 16,
        textAlign: 'center',
        marginTop: 1,
        marginBottom: 5,
        opacity: 0.5,
        top: 0,
        bottom: 350,
    },
    infoContainer: {
        position: 'absolute',
        left: 0,
        right: 0,
        top: 340,
        bottom: 100,
        height: 120,
        padding: 15,

    },
    input: {
        height: 40,
        backgroundColor: 'white',
        marginBottom: 20,
        paddingHorizontal: 10,
        borderStyle: 'solid',
        borderRadius: 10,
    },
    buttonContainer: {
        backgroundColor: 'lightblue',
        paddingVertical: 15,
        borderRadius: 10,
    },
    buttonText: {
        textAlign: 'center',
        color: 'black',
        fontWeight: 'bold',
        fontSize: 16,
    },
})